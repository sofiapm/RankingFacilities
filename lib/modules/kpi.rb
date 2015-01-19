module Kpi

	###################################################################################################################
	#
	# Metodos de Apoio
	#
	###################################################################################################################
	# def self.measures_output facility
	# 	measures = facility.measures.sort_by{|vn| vn[:date]}
	# 	final=[]
	# 	RankingFacilities::Application::METRIC_NAMES.each do |mn|
	# 		array = []
	# 		measures.each do |m|
	# 			if m.name.to_sym == mn[0]
	# 				array << m.value
	# 			end
	# 		end
	# 		final << {:values => array, :name => mn[1]}
	# 	end
	# 	return final
	# end

	#dado um array de valores de um ano, calcula a média de cada trimestre
	def self.calc_quarter_average results
		if results.size>0
			result_by_quarter=results.in_groups(4)
			avg_by_quarter = []
			result_by_quarter.each do |r|
				if r
					avg_by_quarter << r.sum / r.size.to_f
				else
					avg_by_quarter << 'error'
				end
			end
		else
			
			avg_by_quarter=['error','error','error','error']
		end
		avg_by_quarter
	end

	# posso criar funcao para verificar os outros filtros, que chama esta
	# calcula o indicador para todas as facilities e escolhe a que tem melhor media
	# def self.avg(indicator_method, year)
	# 	facilities = Facility.all
	# 	best_average = {}
	# 	facilities.each do |f|
	# 		results=indicator_method.call(f, year)
	# 		average=results[:values].sum / results[:values].size.to_f
	# 		if !best_average[:average]
	# 			best_average = {:results => results, :average => average}
	# 		else 
	# 			if average < best_average[:average]
	# 				best_average = {:results => results, :average => average}
	# 			end
	# 		end
	# 	end
	# 	best_average
	# end

	def self.avg array
		if array.size > 0
			average = array.sum / array.size.to_f
		else 
			average = nil
		end
	end

	#devolve um array com todos os valores de uma determinada measure ordenada por data
	#pode corresponder a um determinado ano
	def self.measurement *args
		facility=args[0]
		nome_measure = args[1]
		year=args[2]

		if !year or year == ""
			measures = facility.measures.where(name: nome_measure).sort_by{|vn| vn[:date]}
		else
			measures = facility.measures.where("strftime('%Y', start_date) <= ? AND strftime('%Y', end_date) >= ? AND name = ?", year.to_i.to_s, year.to_i.to_s, nome_measure).sort_by{|vn| vn[:date]}
		end 
			
		array = []
		measures.each do |m|
			array << m.value
		end
		if measures.first
			year = measures.first.end_date.year
		end

		{value: array, year: year}
	end

	#devolve um array com todos os valores de uma determinada measure estatica ordenada por data
	#pode corresponder a um determinado ano
	def self.static_measurement *args
		facility=args[0]
		nome_measure = args[1]
		year=args[2]

		if !year or year == ""
			measures = FacilityStaticMeasure.where(facility_id: facility.id, name: nome_measure).sort_by{|vn| vn[:date]}
		else
			measures = FacilityStaticMeasure.where(facility_id: facility.id, name: nome_measure).where("strftime('%Y', start_date) <= ? AND strftime('%Y', end_date) >= ?", year.to_i.to_s, year.to_i.to_s).sort_by{|vn| vn[:date]}
		end 
		
		array = []
		measures.each do |m|
			array << m.value
		end

		if measures.first
			year = measures.first.start_date.year
		end
	
		{value: array, year: year}
	end

	# verifica qual a facility com melhores resultados de um determinado KPI
	def self.best_method method, facilities, year
		best_average = {}
		facilities.each do |f|

			results = send(method, f, year)
			
			average = avg results[:values]
			
			unless best_average[:average]
				best_average = {:results => results, :average => average}
			else 
				if average and average < best_average[:average] #se der NaN, entao da menor..
					best_average = {:results => results, :average => average}
				end
			end
		end
		best_average
	end


	#se nao tiver city ou country, compara com todas
	# def self.filter_facilities (city, country, sector)
	# 	facilities = []


	# 	if (city == '' or !city or !Address.where('city = ?', city).first) and (country == '' or !country or !Address.where('country = ?', country).first)
	# 		facilities = Facility.all
	# 	elsif !(city == '' or !city or !Address.where('city = ?', city).first) and !(country == '' or !country or !Address.where('country = ?', country).first)
	# 		Address.where('city = ? AND country = ?', city, country).each do |a|

	# 			facilities << a.facility
	# 		end
	# 	elsif !(city == '' or !city or !Address.where('city = ?', city).first)
	# 		Address.where('city = ?', city).each do |a|
				
	# 			facilities << a.facility
	# 		end
	# 	else
	# 		Address.where('country = ?', country).each do |a|
			
	# 			facilities << a.facility
	# 		end
	# 	end


	# 	facilities
	# end

	def self.specify_year year
		
		if year == '' or !year
			year = Date.current.year
		end
		
		year
		
	end


	###################################################################################################################
	#
	# Metodos de Calculo de Indicadores
	#
	###################################################################################################################

	#calcula o indicador
	#pega em dois arrays do mesmo tamanho - se nao houver falta de insercao de measures
	#utiliza-os para o calculo
	def self.internal_work_cost(facility, year)

		h_tlc = measurement(facility, RankingFacilities::Application::METRIC_NAMES[:tlc], year)
		h_ae = measurement(facility, RankingFacilities::Application::METRIC_NAMES[:ae], year)

		array = []
		i=0
		while i < h_tlc[:value].size do
			array << (h_tlc[:value][i].to_f / h_ae[:value][i].to_f ) *100
			i = i + 1
		end
		
		{:values => array, :name => RankingFacilities::Application::KPI_NAMES[:iwc], :facility_name => facility.name ,
			:type => RankingFacilities::Application::KPI_UNITS[:iwc], :x => :tlc, :y => :ae, :year => h_tlc[:year]}
	end


	# Encontra os resultados da melhor facility relativamente a este indicador
	def self.best_internal_work_cost(facility, year, facilities)

		year = specify_year year

		my_facility_results=internal_work_cost(facility, year)

		facilities = facilities || Facility.all
		
		best_average = best_method :internal_work_cost, facilities, year

		my_facility_results[:values] = calc_quarter_average(my_facility_results[:values])
		best_average[:results][:values] = calc_quarter_average(best_average[:results][:values])

		{:my_facility_results => my_facility_results, :best_facility_results => best_average[:results][:values]}
	end

	def self.water_consumption_fte(facility, year)
		h_wc = measurement(facility, RankingFacilities::Application::METRIC_NAMES[:wc], year)
		h_fte = measurement(facility, RankingFacilities::Application::METRIC_NAMES[:fte], year)
		array = []
		i=0
		while i < h_wc[:value].size do
			array << h_wc[:value][i].to_f / h_fte[:value][i].to_f 
			i = i + 1
		end

		{:values => array, :name => RankingFacilities::Application::KPI_NAMES[:wc_fte], :facility_name => facility.name ,
			:type => RankingFacilities::Application::KPI_UNITS[:wc_fte], :x => :wc, :y => :fte, :year => h_wc[:year]}
	end

	def self.best_water_consumption_fte(facility, year, facilities)
		year = specify_year year
		my_facility_results=water_consumption_fte(facility, year)
		facilities = facilities || Facility.all
		best_average = best_method :water_consumption_fte, facilities, year
		
		my_facility_results[:values] = calc_quarter_average(my_facility_results[:values])
		best_average[:results][:values] = calc_quarter_average(best_average[:results][:values])

	
		{:my_facility_results => my_facility_results, :best_facility_results => best_average[:results][:values]}
	end

	def self.waste_production_fte(facility, year)
		h_wp = measurement(facility, RankingFacilities::Application::METRIC_NAMES[:wp], year)
		h_fte = measurement(facility, RankingFacilities::Application::METRIC_NAMES[:fte], year)
		array = []
		i=0
		while i < h_wp[:value].size do
			array << h_wp[:value][i].to_f / h_fte[:value][i].to_f 
			i = i + 1
		end

		{:values => array, :name => RankingFacilities::Application::KPI_NAMES[:wp_fte], :facility_name => facility.name ,
			:type => RankingFacilities::Application::KPI_UNITS[:wp_fte], :x => :wp, :y => :fte, :year => h_wp[:year]}
	end

	def self.best_waste_production_fte(facility, year, facilities)
		year = specify_year year
		my_facility_results=waste_production_fte(facility, year)
		facilities = facilities || Facility.all
		best_average = best_method :waste_production_fte, facilities, year
		
		my_facility_results[:values] = calc_quarter_average(my_facility_results[:values])
		best_average[:results][:values] = calc_quarter_average(best_average[:results][:values])

	
		{:my_facility_results => my_facility_results, :best_facility_results => best_average[:results][:values]}
	end

	def self.capacity_vs_utilization(facility, year)
		h_nfa = static_measurement(facility, RankingFacilities::Application::ATTRIBUTES_NAMES[:nfa], year)
		h_fte = measurement(facility, RankingFacilities::Application::METRIC_NAMES[:fte], year)
		array = []
		i=0
		while i < h_fte[:value].size do
			array << h_nfa[:value][0].to_f / h_fte[:value][i].to_f 
			i = i + 1
		end

		{:values => array, :name => RankingFacilities::Application::KPI_NAMES[:cu], :facility_name => facility.name ,
			:type => RankingFacilities::Application::KPI_UNITS[:cu], :x => :nfa, :y => :fte, :year => h_fte[:year]}
	end

	def self.best_capacity_vs_utilization(facility, year, facilities)
		year = specify_year year
		my_facility_results=capacity_vs_utilization(facility, year)
		facilities = facilities || Facility.all
		best_average = best_method :capacity_vs_utilization, facilities, year
		
		my_facility_results[:values] = calc_quarter_average(my_facility_results[:values])
		best_average[:results][:values] = calc_quarter_average(best_average[:results][:values])

	
		{:my_facility_results => my_facility_results, :best_facility_results => best_average[:results][:values]}
	end

	def self.space_experience(facility, year)
		h_nfa = static_measurement(facility, RankingFacilities::Application::ATTRIBUTES_NAMES[:nfa], year)
		h_pa = static_measurement(facility, RankingFacilities::Application::ATTRIBUTES_NAMES[:pa], year)
		array = []
		i=0
		while i < h_nfa[:value].size do
			array << (h_nfa[:value][i].to_f / h_pa[:value][i].to_f)*100 
			i = i + 1
		end

		{:values => array, :name => RankingFacilities::Application::KPI_NAMES[:se], :facility_name => facility.name ,
			:type => RankingFacilities::Application::KPI_UNITS[:se], :x => :pa, :y => :nfa, :year => h_nfa[:year]}
	end

	def self.best_space_experience(facility, year, facilities)
		year = specify_year year
		my_facility_results=space_experience(facility, year)
		facilities = facilities || Facility.all
		best_average = best_method :space_experience, facilities, year
		
		my_facility_results[:values] = calc_quarter_average(my_facility_results[:values])
		best_average[:results][:values] = calc_quarter_average(best_average[:results][:values])

	
		{:my_facility_results => my_facility_results, :best_facility_results => best_average[:results][:values]}
	end

	def self.energy_consumption(facility, year)
		h_nfa = static_measurement(facility, RankingFacilities::Application::ATTRIBUTES_NAMES[:nfa], year)
		h_ec = measurement(facility, RankingFacilities::Application::METRIC_NAMES[:ec], year)
		array = []
		i=0
		while i < h_ec[:value].size do
			array << h_ec[:value][i].to_f / h_nfa[:value][0].to_f 
			i = i + 1
		end

		{:values => array, :name => RankingFacilities::Application::KPI_NAMES[:ec_nfa], :facility_name => facility.name ,
			:type => RankingFacilities::Application::KPI_UNITS[:ec_nfa], :x => :ec, :y => :nfa, :year => h_ec[:year]}
	end

	def self.best_energy_consumption(facility, year, facilities)
		year = specify_year year
		my_facility_results=energy_consumption(facility, year)
		facilities = facilities || Facility.all
		best_average = best_method :energy_consumption, facilities, year
		
		my_facility_results[:values] = calc_quarter_average(my_facility_results[:values])
		best_average[:results][:values] = calc_quarter_average(best_average[:results][:values])

	
		{:my_facility_results => my_facility_results, :best_facility_results => best_average[:results][:values]}
	end

	def self.cleaning_cost_nfa (facility, year)
		h_nfa = static_measurement(facility, RankingFacilities::Application::ATTRIBUTES_NAMES[:nfa], year)
		h_tcc = measurement(facility, RankingFacilities::Application::METRIC_NAMES[:tcc], year)
		array = []
		i=0
		if h_nfa[:value].size>0
			while i < h_tcc[:value].size do
				array << h_tcc[:value][i].to_f / h_nfa[:value][0].to_f 
				i = i + 1
			end
		end

		{:values => array, :name => RankingFacilities::Application::KPI_NAMES[:cc_nfa], :facility_name => facility.name ,
			:type => RankingFacilities::Application::KPI_UNITS[:cc_nfa], :x => :tcc, :y => :nfa, :year => h_tcc[:year]}
	end

	def self.best_cleaning_cost_nfa(facility, year, facilities)
		year = specify_year year
		my_facility_results=cleaning_cost_nfa(facility, year)
		facilities = facilities || Facility.all
		best_average = best_method :cleaning_cost_nfa, facilities, year
		
		my_facility_results[:values] = calc_quarter_average(my_facility_results[:values])
		best_average[:results][:values] = calc_quarter_average(best_average[:results][:values])

	
		{:my_facility_results => my_facility_results, :best_facility_results => best_average[:results][:values]}
	end

	def self.space_cost_nfa (facility, year)
		h_nfa = static_measurement(facility, RankingFacilities::Application::ATTRIBUTES_NAMES[:nfa], year)
		h_tsc = measurement(facility, RankingFacilities::Application::METRIC_NAMES[:tsc], year)
		array = []
		i=0
		if h_nfa[:value].size>0
			while i < h_tsc[:value].size do
				array << h_tsc[:value][i].to_f / h_nfa[:value][0].to_f 
				i = i + 1
			end
		end
		{:values => array, :name => RankingFacilities::Application::KPI_NAMES[:sc_nfa], :facility_name => facility.name ,
			:type => RankingFacilities::Application::KPI_UNITS[:sc_nfa], :x => :tsc, :y => :nfa, :year => h_tsc[:year]}
	end

	def self.best_space_cost_nfa(facility, year, facilities)
		year = specify_year year
		my_facility_results=space_cost_nfa(facility, year)
		facilities = facilities || Facility.all
		best_average = best_method :space_cost_nfa, facilities, year
		
		my_facility_results[:values] = calc_quarter_average(my_facility_results[:values])
		best_average[:results][:values] = calc_quarter_average(best_average[:results][:values])

	
		{:my_facility_results => my_facility_results, :best_facility_results => best_average[:results][:values]}
	end

	def self.occupancy_cost_nfa (facility, year)
		h_nfa = static_measurement(facility, RankingFacilities::Application::ATTRIBUTES_NAMES[:nfa], year)
		h_toc = measurement(facility, RankingFacilities::Application::METRIC_NAMES[:toc], year)
		array = []
		i=0

		if h_nfa[:value].size>0
			while i < h_toc[:value].size do
				array << h_toc[:value][i].to_f / h_nfa[:value][0].to_f 
				i = i + 1
			end
		else 
			array << 0 #da erro
		end

		{:values => array, :name => RankingFacilities::Application::KPI_NAMES[:oc_nfa], :facility_name => facility.name ,
			:type => RankingFacilities::Application::KPI_UNITS[:oc_nfa], :x => :toc, :y => :nfa, :year => h_toc[:year]}
	end

	def self.best_occupancy_cost_nfa(facility, year, facilities)
		year = specify_year year
		my_facility_results = occupancy_cost_nfa(facility, year)

		facilities = facilities || Facility.all

        best_average = best_method :occupancy_cost_nfa, facilities, year
		
		my_facility_results[:values] = calc_quarter_average(my_facility_results[:values])
		best_average[:results][:values] = calc_quarter_average(best_average[:results][:values])

		{:my_facility_results => my_facility_results, :best_facility_results => best_average[:results][:values]}
	end

	#substituir por cleaning, space e occupancy costs
	def self.costs_year facility
		year = Date.current.year
		hash = {:first => {:name => year-2, :values => [avg(cleaning_cost_nfa(facility, (year-2).to_s)[:values]), avg(space_cost_nfa(facility, (year-2).to_s)[:values]), avg(occupancy_cost_nfa(facility, (year-2).to_s)[:values])]}}
		hash[:second]={:name => year-1, :values => [avg(cleaning_cost_nfa(facility, (year-1).to_s)[:values]), avg(space_cost_nfa(facility, (year-1).to_s)[:values]), avg(occupancy_cost_nfa(facility, (year-1).to_s)[:values]) ]}
		hash[:third]={:name => year, :values => [avg(cleaning_cost_nfa(facility, year.to_s)[:values]), avg(space_cost_nfa(facility, year.to_s)[:values]), avg(occupancy_cost_nfa(facility, year.to_s)[:values]) ]}
		hash[:categories] = ["Cleaning", "Space", "Occupancy"]
		hash[:graph_name] = 'Cost per NFA'
		hash
	end


end