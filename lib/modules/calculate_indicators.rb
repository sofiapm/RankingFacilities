module CalculateIndicators

	def self.measurement *args
		facility=args[0]
		nome_measure = args[1]
		insert_date=args[2] #created_at

		# measures = facility.measures.where(name: nome_measure, updated_at: insert_date).sort_by{|vn| vn[:date]}
		measures = facility.measures.where("Date(updated_at) = ? AND name= ?", insert_date.to_date, nome_measure).sort_by{|vn| vn[:start_date]}

		array_granular_measures = []
		#vai buscar as granular measures (valores da medida por dia de cada mês) de cada measure
		measures.each do |m|
			array_granular_measures = array_granular_measures + GranularMeasure.where(measure_id: m.id)
		end
		
		#array_granular_measures=array_granular_measures.sort_by{|vn| vn[:date]}
		#agrupa todas as granular measures por mês e ano
		#{[12, 2013]=> [#<GranularMeasure id: 2590, value: 0.3, day: "2013-12-11", measure_id: 86, created_at: "2015-01-19 16:10:10", updated_at: "2015-01-19 16:10:10">,
		grouped_array_granular_measures=array_granular_measures.group_by { |x| [x.day.month, x.day.year] }
		
		#[[{:date=>[1, 2014], :n_months=>29998.709999999977}],[{:date=>[2, 2014], :n_months=>33331.89999999997}],[{:date=>[3, 2014], :n_months=>29998.709999999977}],
		#[{:date=>[4, 2014], :n_months=>31033.14827586205}], [{:date=>[5, 2014], :n_months=>29998.709999999977}], [{:date=>[6, 2014], :n_months=>31033.14827586205}],
 		#[{:date=>[7, 2014], :n_months=>29998.709999999977}], [{:date=>[8, 2014], :n_months=>29998.709999999977}], [{:date=>[9, 2014], :n_months=>31033.14827586205}],
 		#[{:date=>[10, 2014], :n_months=>29998.709999999977}], [{:date=>[11, 2014], :n_months=>31033.14827586205}], [{:date=>[12, 2014], :n_months=>29998.709999999977}]]
		sum_per_month=[]
		grouped_array_granular_measures.each do |ay|
			sum_per_month << [:date => ay.first , value: ay.second.map(&:value).sum/ay.second.count, :measure_id_first => ay.second.first.id, :measure_id_last => ay.second.last.id]

		end
		
		sum_per_month
	end

	def self.static_measurement *args
		facility=args[0]
		nome_measure = args[1]
		year=args[2]
		firstyear=args[3]
		lastyear=args[4]
		month_per_year = args[5]

		measures = FacilityStaticMeasure.where(facility_id: facility.id, name: nome_measure).sort_by{|vn| vn[:start_date]}
		
		array = []

		#transforma o valor que temos na tabela que corresponde a um intervalo de tempo
		#em diferentes valores 1 de cada mês da static measure para utilizar nos calculos
		measures.each do |m|

			if !month_per_year
				#se month_per_year não existe, é porque estamos a calcular um indicador que apenas utiliza static measures
				#o numero de meses será equivalente a todos os meses a que a medida corresponde data_fim-data_inicio
				#o array terá tantos valores como mesesda medida
			
				array.concat(Array.new((m.end_date.month-m.start_date.month).abs, m.value)) 
				firstyear=m.start_date
				lastyear=m.end_date
			else
				#se existir month_per_year estamos a calcular um indicador com measure e static_measures
				#iteramos sobre cada ano da measure e adicionamos ao array o numero de valores correspondente a cada ano
		
				month_per_year.each do |my|
					#apenas se a measure tiver uma data correspondente à da static_measure
					if m.start_date.year <= my.first[:year] && my.first[:year] <= m.end_date.year
						array.concat(Array.new(my.first[:n_months], m.value))
					end
				end
			end
		end
	
		{value: array, beggining_date: firstyear}
	end

	def self.save_indicators_measures indicator_id, measure_id
			ind_gran_mea=IndicatorsMeasure.new
	    	ind_gran_mea.attributes = {"indicators_id"=>indicator_id, "measures_id"=>measure_id}
	    	ind_gran_mea.save!
	end

	def self.save_and_verify_indicator_measure indicator_id, measure_first_id, measure_last_id
		
		while measure_first_id < measure_last_id do
			save_indicators_measures(indicator_id, measure_first_id)
			measure_first_id = measure_first_id + 1
		end
		save_indicators_measures(indicator_id, measure_last_id)

	end

	def self.internal_work_cost(facility, created_at)

		h_tlc = measurement(facility, RankingFacilities::Application::METRIC_NAMES[:tlc], created_at)
		h_ae = measurement(facility, RankingFacilities::Application::METRIC_NAMES[:ae], created_at)
		i=0

		while i < h_tlc.size do
			indicator=Indicator.new
			indicator.attributes = {"id"=>nil, "facility_id"=>facility.id, "name"=>RankingFacilities::Application::KPI_NAMES[:iwc], "value"=>((h_tlc[i].first[:value].to_f/h_ae[i].first[:value].to_f )*100).round(4), "date"=>Date.new(h_tlc[i].first[:date].second,h_tlc[i].first[:date].first)}
	    	indicator.save!
	    	save_and_verify_indicator_measure(indicator.id, h_tlc[i].first[:measure_id_first], h_tlc[i].first[:measure_id_last])
	    	save_and_verify_indicator_measure(indicator.id, h_ae[i].first[:measure_id_first], h_ae[i].first[:measure_id_last])
			i = i + 1
		end
	end

	def self.update_internal_work_cost (gmeasure)
		indicator = Indicator.find(IndicatorsMeasure.where("measures_id = ?", gmeasure.id).first.indicators_id)

		h_tlc = measurement(gmeasure.measure.facility, RankingFacilities::Application::METRIC_NAMES[:tlc], gmeasure.measure.created_at)
		h_ae = measurement(gmeasure.measure.facility, RankingFacilities::Application::METRIC_NAMES[:ae], gmeasure.measure.created_at)

		i=0
		while i < h_tlc.size do
			indicator.update({"id"=>indicator.id, "facility_id"=>gmeasure.measure.facility, "name"=>RankingFacilities::Application::KPI_NAMES[:iwc], "value"=>((h_tlc[i].first[:value].to_f/h_ae[i].first[:value].to_f )*100).round(4), "date"=>Date.new(h_tlc[i].first[:date].second,h_tlc[i].first[:date].first)})
			i=i+1
		end
	end

	def self.water_consumption_fte(facility, created_at)
		h_wc = measurement(facility, RankingFacilities::Application::METRIC_NAMES[:wc], created_at)
		h_fte = static_measurement(facility, RankingFacilities::Application::ATTRIBUTES_NAMES[:fte], h_wc.first.first[:date].second, h_wc.last.first[:date].second, h_wc.count)
		
		
		i=0
		while i < h_wc.size do
			indicator=Indicator.new
			indicator.attributes = {"id"=>nil, "facility_id"=>facility.id, "name"=>RankingFacilities::Application::KPI_NAMES[:wc_fte], "value"=>((h_wc[i].first[:value].to_f/h_fte[:value][i].to_f )).round(4), "date"=>Date.new(h_wc[i].first[:date].second,h_wc[i].first[:date].first)}
	    	indicator.save!
	    	save_and_verify_indicator_measure(indicator.id, h_wc[i].first[:measure_id_first], h_wc[i].first[:measure_id_last])
			i = i + 1
		end
	end

	def self.update_water_consumption_fte (gmeasure)
		indicator = Indicator.find(IndicatorsMeasure.where("measures_id = ?", gmeasure.id).first.indicators_id)

		h_wc = measurement(gmeasure.measure.facility, RankingFacilities::Application::METRIC_NAMES[:wc], gmeasure.measure.created_at)
		h_fte  = static_measurement(gmeasure.measure.facility, RankingFacilities::Application::ATTRIBUTES_NAMES[:fte], h_wc.first.first[:date].second, h_wc.last.first[:date].second, h_wc.count)
		
		i=0
		while i < h_wc.size do
			indicator.update({"id"=>indicator.id, "facility_id"=>gmeasure.measure.facility, "name"=>RankingFacilities::Application::KPI_NAMES[:wc_fte], "value"=>((h_wc[i].first[:value].to_f/h_fte[:value][i].to_f )).round(4), "date"=>Date.new(h_wc[i].first[:date].second,h_wc[i].first[:date].first)})
			i = i + 1
		end
	end

	def self.waste_production_fte(facility, created_at)
		h_wp = measurement(facility, RankingFacilities::Application::METRIC_NAMES[:wp], created_at)
		h_fte  = static_measurement(facility, RankingFacilities::Application::ATTRIBUTES_NAMES[:fte], h_wp.first.first[:date].second, h_wp.last.first[:date].second, h_wp.count)
		
		i=0
		while i < h_wp.size do
			indicator=Indicator.new
			indicator.attributes = {"id"=>nil,"facility_id"=>facility.id, "name"=>RankingFacilities::Application::KPI_NAMES[:wp_fte], "value"=>((h_wp[i].first[:value].to_f/h_fte[:value][i].to_f )).round(4), "date"=>Date.new(h_wp[i].first[:date].second,h_wp[i].first[:date].first)}
	    	indicator.save!
	    	save_and_verify_indicator_measure(indicator.id, h_wp[i].first[:measure_id_first], h_wp[i].first[:measure_id_last])
			i = i + 1
		end

	end

	def self.update_waste_production_fte (gmeasure)
		indicator = Indicator.find(IndicatorsMeasure.where("measures_id = ?", gmeasure.id).first.indicators_id)

		h_wp = measurement(gmeasure.measure.facility, RankingFacilities::Application::METRIC_NAMES[:wp], gmeasure.measure.created_at)
		h_fte  = static_measurement(gmeasure.measure.facility, RankingFacilities::Application::ATTRIBUTES_NAMES[:fte], h_wp.first.first[:date].second, h_wp.last.first[:date].second, h_wp.count)
		
		i=0
		while i < h_wp.size do
			indicator.update({"id"=>indicator.id, "facility_id"=>gmeasure.measure.facility, "name"=>RankingFacilities::Application::KPI_NAMES[:wp_fte], "value"=>((h_wp[i].first[:value].to_f/h_fte[:value][i].to_f )).round(4), "date"=>Date.new(h_wp[i].first[:date].second,h_wp[i].first[:date].first)})
			i=i+1
		end
	end

	def self.energy_consumption(facility, created_at)
		h_ec = measurement(facility, RankingFacilities::Application::METRIC_NAMES[:ec], created_at)
		h_nfa = static_measurement(facility, RankingFacilities::Application::ATTRIBUTES_NAMES[:nfa], h_ec.first.first[:date].second, h_ec.last.first[:date].second, h_ec.count)
		
		
		i=0
		while i < h_ec.size do
			indicator=Indicator.new
			indicator.attributes = {"id"=>nil, "facility_id"=>facility.id, "name"=>RankingFacilities::Application::KPI_NAMES[:ec_nfa], "value"=>((h_ec[i].first[:value].to_f/h_nfa[:value][i].to_f )).round(4), "date"=>Date.new(h_ec[i].first[:date].second,h_ec[i].first[:date].first)}
	    	indicator.save!
	    	save_and_verify_indicator_measure(indicator.id, h_ec[i].first[:measure_id_first], h_ec[i].first[:measure_id_last])
			i = i + 1
		end

	end

	def self.update_energy_consumption (gmeasure)
		indicator = Indicator.find(IndicatorsMeasure.where("measures_id = ?", gmeasure.id).first.indicators_id)

		h_ec = measurement(gmeasure.measure.facility, RankingFacilities::Application::METRIC_NAMES[:ec], gmeasure.measure.created_at)
		h_nfa = static_measurement(gmeasure.measure.facility, RankingFacilities::Application::ATTRIBUTES_NAMES[:nfa], h_ec.first.first[:date].second, h_ec.last.first[:date].second, h_ec.count)

		i=0
		while i < h_ec.size do
			indicator.update({"id"=>indicator.id, "facility_id"=>gmeasure.measure.facility, "name"=>RankingFacilities::Application::KPI_NAMES[:ec_nfa], "value"=>((h_ec[i].first[:value].to_f/h_nfa[:value][i].to_f )).round(4), "date"=>Date.new(h_ec[i].first[:date].second,h_ec[i].first[:date].first)})
			i=i+1
		end
	end

	def self.cleaning_cost_nfa (facility, created_at)
		h_tcc = measurement(facility, RankingFacilities::Application::METRIC_NAMES[:tcc], created_at)
		h_nfa = static_measurement(facility, RankingFacilities::Application::ATTRIBUTES_NAMES[:nfa], h_tcc.first.first[:date].second, h_tcc.last.first[:date].second, h_tcc.count)
		
	
		i=0
		if h_nfa[:value].size>0
			while i < h_tcc.size do
				indicator=Indicator.new
				indicator.attributes = {"id"=>nil, "facility_id"=>facility.id, "name"=>RankingFacilities::Application::KPI_NAMES[:cc_nfa], "value"=>((h_tcc[i].first[:value].to_f/h_nfa[:value][i].to_f )).round(4), "date"=>Date.new(h_tcc[i].first[:date].second, h_tcc[i].first[:date].first)}
	    		indicator.save!
	    		save_and_verify_indicator_measure(indicator.id, h_tcc[i].first[:measure_id_first], h_tcc[i].first[:measure_id_last])
				i = i + 1
			end
		end
	end

	def self.update_cleaning_cost_nfa (gmeasure)
		indicator = Indicator.find(IndicatorsMeasure.where("measures_id = ?", gmeasure.id).first.indicators_id)

		h_tcc = measurement(gmeasure.measure.facility, RankingFacilities::Application::METRIC_NAMES[:tcc], gmeasure.measure.created_at)
		h_nfa = static_measurement(gmeasure.measure.facility, RankingFacilities::Application::ATTRIBUTES_NAMES[:nfa], h_tcc.first.first[:date].second, h_tcc.last.first[:date].second, h_tcc.count)

		i=0
		while i < h_tcc.size do
			indicator.update({"id"=>indicator.id, "facility_id"=>gmeasure.measure.facility, "name"=>RankingFacilities::Application::KPI_NAMES[:cc_nfa], "value"=>((h_tcc[i].first[:value].to_f/h_nfa[:value][i].to_f )).round(4), "date"=>Date.new(h_tcc[i].first[:date].second, h_tcc[i].first[:date].first)})
			i=i+1
		end
	end

	def self.space_cost_nfa (facility, created_at)
		h_tsc = measurement(facility, RankingFacilities::Application::METRIC_NAMES[:tsc], created_at)
		h_nfa = static_measurement(facility, RankingFacilities::Application::ATTRIBUTES_NAMES[:nfa], h_tsc.first.first[:date].second, h_tsc.last.first[:date].second, h_tsc.count)
		
	
		i=0
	
			while i < h_tsc.size do
				indicator=Indicator.new
				indicator.attributes = {"id"=>nil, "facility_id"=>facility.id, "name"=>RankingFacilities::Application::KPI_NAMES[:sc_nfa], "value"=>((h_tsc[i].first[:value].to_f/h_nfa[:value][i].to_f )).round(4), "date"=>Date.new(h_tsc[i].first[:date].second, h_tsc[i].first[:date].first)}
	    		indicator.save!
	    		save_and_verify_indicator_measure(indicator.id, h_tsc[i].first[:measure_id_first], h_tsc[i].first[:measure_id_last])
				i = i + 1
			end
	end

	def self.update_space_cost_nfa (gmeasure)
		indicator = Indicator.find(IndicatorsMeasure.where("measures_id = ?", gmeasure.id).first.indicators_id)

		h_tsc = measurement(gmeasure.measure.facility, RankingFacilities::Application::METRIC_NAMES[:tsc], gmeasure.measure.created_at)
		h_nfa = static_measurement(gmeasure.measure.facility, RankingFacilities::Application::ATTRIBUTES_NAMES[:nfa], h_tsc.first.first[:date].second, h_tsc.last.first[:date].second, h_tsc.count)

		i=0
		while i < h_tsc.size do
			indicator.update({"id"=>indicator.id, "facility_id"=>gmeasure.measure.facility, "name"=>RankingFacilities::Application::KPI_NAMES[:sc_nfa], "value"=>((h_tsc[i].first[:value].to_f/h_nfa[:value][i].to_f )).round(4), "date"=>Date.new(h_tsc[i].first[:date].second, h_tsc[i].first[:date].first)})
			i=i+1
		end
	end

	def self.occupancy_cost_nfa (facility, created_at)
		h_toc = measurement(facility, RankingFacilities::Application::METRIC_NAMES[:toc], created_at)
		h_nfa = static_measurement(facility, RankingFacilities::Application::ATTRIBUTES_NAMES[:nfa], h_toc.first.first[:date].second, h_toc.last.first[:date].second, h_toc.count)
		
		i=0

			while i < h_toc.size do
				indicator=Indicator.new
				indicator.attributes = {"id"=>nil, "facility_id"=>facility.id, "name"=>RankingFacilities::Application::KPI_NAMES[:oc_nfa], "value"=>((h_toc[i].first[:value].to_f/h_nfa[:value][i].to_f )).round(4), "date"=>Date.new(h_toc[i].first[:date].second, h_toc[i].first[:date].first)}
	    		indicator.save!
	    		save_and_verify_indicator_measure(indicator.id, h_toc[i].first[:measure_id_first], h_toc[i].first[:measure_id_last])
				i = i + 1
			end
	end

	def self.update_occupancy_cost_nfa (gmeasure)
		indicator = Indicator.find(IndicatorsMeasure.where("measures_id = ?", gmeasure.id).first.indicators_id)

		h_toc = measurement(gmeasure.measure.facility, RankingFacilities::Application::METRIC_NAMES[:toc], gmeasure.measure.created_at)
		h_nfa = static_measurement(gmeasure.measure.facility, RankingFacilities::Application::ATTRIBUTES_NAMES[:nfa], h_toc.first.first[:date].second, h_toc.last.first[:date].second, h_toc.count)

		i=0
		while i < h_toc.size do
			indicator.update({"id"=>indicator.id, "facility_id"=>gmeasure.measure.facility, "name"=>RankingFacilities::Application::KPI_NAMES[:oc_nfa], "value"=>((h_toc[i].first[:value].to_f/h_nfa[:value][i].to_f )).round(4), "date"=>Date.new(h_toc[i].first[:date].second, h_toc[i].first[:date].first)})
			i=i+1
		end
	end

	def self.capacity_vs_utilization(facility)
		h_fte = static_measurement(facility, RankingFacilities::Application::ATTRIBUTES_NAMES[:fte])
		h_nfa = static_measurement(facility, RankingFacilities::Application::ATTRIBUTES_NAMES[:nfa])

		i=0
		initial_date=h_nfa[:beggining_date]
		while i < h_nfa[:value].size do
			indicator=Indicator.new
			indicator.attributes = {"id"=>nil, "facility_id"=>facility.id, "name"=>RankingFacilities::Application::KPI_NAMES[:cu], "value"=>((h_nfa[:value][i].to_f / h_fte[:value][i].to_f)).round(4), "date"=>initial_date}
	    	indicator.save!
	    	initial_date >> 1
			i = i + 1
		end

	end

	def self.space_experience(facility)
		h_nfa = static_measurement(facility, RankingFacilities::Application::ATTRIBUTES_NAMES[:nfa])
		h_pa = static_measurement(facility, RankingFacilities::Application::ATTRIBUTES_NAMES[:pa])
		
		i=0
		initial_date=h_nfa[:beggining_date]
		while i < h_nfa[:value].size do
			indicator=Indicator.new
			indicator.attributes = {"id"=>nil, "facility_id"=>facility.id, "name"=>RankingFacilities::Application::KPI_NAMES[:se], "value"=>((h_nfa[:value][i].to_f / h_pa[:value][i].to_f)*100 ).round(4), "date"=>initial_date}
	    	indicator.save!
	    	initial_date >> 1
			i = i + 1
		end
	end

	def self.calculate_indicators facility, created_at
		internal_work_cost(facility, created_at)
		water_consumption_fte(facility, created_at)
		# waste_production_fte(facility, created_at)
		energy_consumption(facility, created_at)
		cleaning_cost_nfa(facility, created_at)
		space_cost_nfa(facility, created_at)
		occupancy_cost_nfa(facility, created_at)
		capacity_vs_utilization(facility)
		space_experience(facility)
	end

	def self.update_indicators gmeasure
		case gmeasure.measure.name
		when RankingFacilities::Application::METRIC_NAMES[:tlc] || RankingFacilities::Application::METRIC_NAMES[:ae]
			update_internal_work_cost(gmeasure)  
		when RankingFacilities::Application::METRIC_NAMES[:toc]
		  	update_occupancy_cost_nfa(gmeasure)
		when RankingFacilities::Application::METRIC_NAMES[:tsc]
		  	update_space_cost_nfa(gmeasure)
		when RankingFacilities::Application::METRIC_NAMES[:tcc]
			update_cleaning_cost_nfa(gmeasure)
		when RankingFacilities::Application::METRIC_NAMES[:ec]
			update_energy_consumption(gmeasure)
		when RankingFacilities::Application::METRIC_NAMES[:wp]
			update_waste_production_fte(gmeasure)
		when RankingFacilities::Application::METRIC_NAMES[:wc]
			update_water_consumption_fte(gmeasure)
		else
		  puts "Name of measure dont correspond any existent one. Cant update indicators"
		end
	end


end


