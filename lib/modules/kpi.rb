module Kpi

	###################################################################################################################
	#
	# Metodos de Apoio
	#
	###################################################################################################################

	#dado um array de valores de um ano, calcula a média de cada trimestre
	def self.calc_quarter_average results
		
		if results.size>0
			result_by_quarter=results.in_groups(4, 0)
			avg_by_quarter = []

			result_by_quarter.each do |r|
				if r
					avg_by_quarter << r.sum / r.size.to_f
				else
					avg_by_quarter << 0
				end
			end
		else
			
			avg_by_quarter=[ ]
		end
		avg_by_quarter
	end

	def self.avg array
		if array.size > 0
			average = array.sum / array.size.to_f
		else 
			average = 0
		end
	end

	# verifica qual a facility com melhores resultados de um determinado KPI
	def self.best_facility_method method, facilities, year
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

	#recebe um array com um valor de medida por cada dia e soma-os para ter o valor do mês
	def self.get_month_value array
		value = 0
		array.each do |a|
			value = value + a.value
		end
		value
	end

	#se o ano nõ tiver especificado anteriormente, então year=ano corrente
	def self.specify_year year
		
		if year == '' or !year
			year = Date.current.year
		end
		
		year
		
	end

	#devolve um array com todos os valores de uma determinada measure ordenada por data
	#pode corresponder a um determinado ano
	#utiliza a tabela da DB com os valores por dia - granular_measure
	def self.measurement *args
		facility=args[0]
		nome_measure = args[1]
		year=args[2]

		unless !year || year == ""
			#se o ano tiver sido especificado no search
			measures = facility.measures.where("extract(year from start_date) <= ? AND extract(year from end_date) >= ? AND name = ?", year.to_i.to_s, year.to_i.to_s, nome_measure).sort_by{|vn| vn[:date]}
		else
			#se não o ano não tiver sido especificado no search
			measures = facility.measures.where(name: nome_measure).sort_by{|vn| vn[:date]}
		end
			
		array_granular_measures = []
		#vai buscar as granular measures (valores da medida por dia de cada mês) de cada measure
		measures.each do |m|
			array_granular_measures = array_granular_measures + GranularMeasure.where(measure_id: m.id)
		end

		array_granular_measures=array_granular_measures.sort_by{|vn| vn[:date]}
		if array_granular_measures.first
			if !year or year == "" 
				year = array_granular_measures.first.day.year
			end
			lastyear = array_granular_measures.last.day.year
		end
		#agrupa todas as granular measures por mês e ano
		#{[12, 2013]=> [#<GranularMeasure id: 2590, value: 0.3, day: "2013-12-11", measure_id: 86, created_at: "2015-01-19 16:10:10", updated_at: "2015-01-19 16:10:10">,
		grouped_array_granular_measures=array_granular_measures.group_by { |x| [x.day.month, x.day.year] }
		
		array_month_value = []
		#itera sobre cada um dos meses do ano
		grouped_array_granular_measures.each do |gm|
				month_value = get_month_value(gm.second)
				#array para fazer os calculos dos indicadores
				array_month_value << month_value 
		end
		
		
		#agrupa o array a por ano
		#{[2013]=> [[[12, 2013], [#<GranularMeasure id: 2590, value: 0.3, day: "2013-12-11", measure_id: 86, created_at: "2015-01-19 16:10:10", updated_at: "2015-01-19 16:10:10">,
		grouped_array_granular_measures=grouped_array_granular_measures.group_by { |x| [x.first.second] }
		
		month_per_year = []
		#conta quantos meses existem em cada ano
		grouped_array_granular_measures.each do |ay|
			month_per_year << [:year => ay.first.first , n_months: ay.second.count]
		end

		{value: array_month_value, year: year, lastyear: lastyear, month_per_year: month_per_year}
	end

	#devolve um array com todos os valores de uma determinada measure estatica ordenada por data
	#pode corresponder a um determinado ano
	def self.static_measurement *args
		facility=args[0]
		nome_measure = args[1]
		year=args[2]
		firstyear=args[3]
		lastyear=args[4]
		month_per_year = args[5]

		if !year || year == ""
			if !firstyear || !lastyear
				measures = FacilityStaticMeasure.where(facility_id: facility.id, name: nome_measure).sort_by{|vn| vn[:start_date]}
			else
				measures = FacilityStaticMeasure.where(facility_id: facility.id, name: nome_measure).where("extract(year from start_date) <= ? AND extract(year from end_date) >= ?", firstyear.to_i.to_s, lastyear.to_i.to_s).sort_by{|vn| vn[:date]}
			end
			
			if measures.first
				year = measures.first.end_date.year
			end
		else
			measures = FacilityStaticMeasure.where(facility_id: facility.id, name: nome_measure).where("extract(year from start_date) <= ? AND extract(year from end_date) >= ?", year.to_i.to_s, year.to_i.to_s).sort_by{|vn| vn[:date]}
		end 
		
		array = []
		#transforma o valor que temos na tabela que corresponde a um intervalo de tempo
		#em diferentes valores 1 de cada mês da static measure para utilizar nos calculos
		measures.each do |m|

			if !month_per_year
				#se month_per_year não existe, é porque estamos a calcular um indicador que apenas utiliza static measures
				#o numero de meses será equivalente a todos os meses a que a medida corresponde data_fim-data_inicio
				#o array terá tantos valores como mesesda medida
			
				array.concat(Array.new((m.end_date.month-m.start_date.month).abs, m.value)) 
			else
				#se existir month_per_year estamos a calcular um indicador com measure e static_measures
				#iteramos sobre cada ano da measure e adicionamos ao array o numero de valores correspondente a cada ano
		
				month_per_year.each do |my|
					#apenas se a measure tiver uma data correspondente à da static_measure
					if m.start_date.year <= my.first[:year] && my.first[:year] <= m.end_date.year
						array.concat(Array.new(my.first[:n_months], m.value))
					# else
					# 	#senao, adiciona o valor zero
					# 	array.concat(Array.new(my.first[:n_months], 0))
					end
				end
			end
		end
	


		{value: array, year: year}
	end

	#Quando nao temos em conta os valores por dia e assumimos que o utilizador coloca os valores de measure do dia 1 ao ultimo dia do mês
	# #devolve um array com todos os valores de uma determinada measure ordenada por data
	# #pode corresponder a um determinado ano
	# def self.measurement *args
	# 	facility=args[0]
	# 	nome_measure = args[1]
	# 	year=args[2]

	# 	if !year or year == ""
	# 		measures = facility.measures.where(name: nome_measure).sort_by{|vn| vn[:start_date]}
	# 	else
	# 		measures = facility.measures.where("extract(year from start_date) <= ? AND extract(year from end_date) >= ? AND name = ?", year.to_i.to_s, year.to_i.to_s, nome_measure).sort_by{|vn| vn[:date]}
	# 	end 
			
	# 	array = []
	# 	measures.each do |m|
	# 		array << m.value
	# 	end
	# 	if measures.first
	# 		year = measures.first.end_date.year
	# 	end

	# 	{value: array, year: year}
	# end

	# #devolve um array com todos os valores de uma determinada measure estatica ordenada por data
	# #pode corresponder a um determinado ano
	# def self.static_measurement *args
	# 	facility=args[0]
	# 	nome_measure = args[1]
	# 	year=args[2]

	# 	if !year or year == ""
	# 		measures = FacilityStaticMeasure.where(facility_id: facility.id, name: nome_measure).sort_by{|vn| vn[:start_date]}
	# 	else
	# 		measures = FacilityStaticMeasure.where(facility_id: facility.id, name: nome_measure).where("extract(year from start_date) <= ? AND extract(year from end_date) >= ?", year.to_i.to_s, year.to_i.to_s).sort_by{|vn| vn[:date]}
	# 	end 
		
	# 	array = []
	# 	measures.each do |m|
	# 		array << m.value
	# 	end

	# 	if measures.first
	# 		year = measures.first.start_date.year
	# 	end
	
	# 	{value: array, year: year}
	# end


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
			array << ((h_tlc[:value][i].to_f / h_ae[:value][i].to_f ) *100).round(4)
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
		
		best_average = best_facility_method :internal_work_cost, facilities, year

		my_facility_results[:values] = calc_quarter_average(my_facility_results[:values])
		best_average[:results][:values] = calc_quarter_average(best_average[:results][:values])

		{:my_facility_results => my_facility_results, :best_facility_results => best_average[:results][:values]}
	end

	def self.water_consumption_fte(facility, year)
		h_wc = measurement(facility, RankingFacilities::Application::METRIC_NAMES[:wc], year)
		h_fte = h_fte = static_measurement(facility, RankingFacilities::Application::ATTRIBUTES_NAMES[:fte], year, h_wc[:year], h_wc[:lastyear], h_wc[:month_per_year])
		
		array = []
		i=0
		while i < h_wc[:value].size do
			array << (h_wc[:value][i].to_f / h_fte[:value][i].to_f ).round(4)
			i = i + 1
		end

		{:values => array, :name => RankingFacilities::Application::KPI_NAMES[:wc_fte], :facility_name => facility.name ,
			:type => RankingFacilities::Application::KPI_UNITS[:wc_fte], :x => :wc, :y => :fte, :year => h_wc[:year]}
	end

	def self.best_water_consumption_fte(facility, year, facilities)
		year = specify_year year
		my_facility_results=water_consumption_fte(facility, year)
		facilities = facilities || Facility.all
		best_average = best_facility_method :water_consumption_fte, facilities, year
		
		my_facility_results[:values] = calc_quarter_average(my_facility_results[:values])
		best_average[:results][:values] = calc_quarter_average(best_average[:results][:values])

	
		{:my_facility_results => my_facility_results, :best_facility_results => best_average[:results][:values]}
	end

	def self.waste_production_fte(facility, year)
		h_wp = measurement(facility, RankingFacilities::Application::METRIC_NAMES[:wp], year)
		h_fte = h_fte = static_measurement(facility, RankingFacilities::Application::ATTRIBUTES_NAMES[:fte], year, h_wp[:year], h_wp[:lastyear], h_wp[:month_per_year])
		array = []
		i=0
		while i < h_wp[:value].size do
			array << (h_wp[:value][i].to_f / h_fte[:value][i].to_f).round(4) 
			i = i + 1
		end

		{:values => array, :name => RankingFacilities::Application::KPI_NAMES[:wp_fte], :facility_name => facility.name ,
			:type => RankingFacilities::Application::KPI_UNITS[:wp_fte], :x => :wp, :y => :fte, :year => h_wp[:year]}
	end

	def self.best_waste_production_fte(facility, year, facilities)
		year = specify_year year
		my_facility_results=waste_production_fte(facility, year)
		facilities = facilities || Facility.all
		best_average = best_facility_method :waste_production_fte, facilities, year
		
		my_facility_results[:values] = calc_quarter_average(my_facility_results[:values])
		best_average[:results][:values] = calc_quarter_average(best_average[:results][:values])

	
		{:my_facility_results => my_facility_results, :best_facility_results => best_average[:results][:values]}
	end

	def self.capacity_vs_utilization(facility, year)
		h_fte = static_measurement(facility, RankingFacilities::Application::ATTRIBUTES_NAMES[:fte], year)
		h_nfa = static_measurement(facility, RankingFacilities::Application::ATTRIBUTES_NAMES[:nfa], year)
		
		array = []
		i=0
		while i < h_fte[:value].size do
			array << (h_nfa[:value][i].to_f / h_fte[:value][i].to_f).round(4) 
			i = i + 1
		end

		{:values => array, :name => RankingFacilities::Application::KPI_NAMES[:cu], :facility_name => facility.name ,
			:type => RankingFacilities::Application::KPI_UNITS[:cu], :x => :nfa, :y => :fte, :year => h_fte[:year]}
	end

	def self.best_capacity_vs_utilization(facility, year, facilities)
		year = specify_year year
		my_facility_results=capacity_vs_utilization(facility, year)
		facilities = facilities || Facility.all
		best_average = best_facility_method :capacity_vs_utilization, facilities, year
		
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
			array << ((h_nfa[:value][i].to_f / h_pa[:value][i].to_f)*100 ).round(4)
			i = i + 1
		end

		{:values => array, :name => RankingFacilities::Application::KPI_NAMES[:se], :facility_name => facility.name ,
			:type => RankingFacilities::Application::KPI_UNITS[:se], :x => :pa, :y => :nfa, :year => h_nfa[:year]}
	end

	def self.best_space_experience(facility, year, facilities)
		year = specify_year year
		my_facility_results=space_experience(facility, year)
		facilities = facilities || Facility.all
		best_average = best_facility_method :space_experience, facilities, year
		
		my_facility_results[:values] = calc_quarter_average(my_facility_results[:values])
		best_average[:results][:values] = calc_quarter_average(best_average[:results][:values])


		{:my_facility_results => my_facility_results, :best_facility_results => best_average[:results][:values]}
	end

	def self.energy_consumption(facility, year)
		h_ec = measurement(facility, RankingFacilities::Application::METRIC_NAMES[:ec], year)
		h_nfa = static_measurement(facility, RankingFacilities::Application::ATTRIBUTES_NAMES[:nfa], year, h_ec[:year], h_ec[:lastyear], h_ec[:month_per_year])
		
		array = []
		i=0
		while i < h_ec[:value].size do
			array << (h_ec[:value][i].to_f / h_nfa[:value][i].to_f ).round(4)
			i = i + 1
		end

		{:values => array, :name => RankingFacilities::Application::KPI_NAMES[:ec_nfa], :facility_name => facility.name ,
			:type => RankingFacilities::Application::KPI_UNITS[:ec_nfa], :x => :ec, :y => :nfa, :year => h_ec[:year]}
	end

	def self.best_energy_consumption(facility, year, facilities)
		year = specify_year year
		my_facility_results=energy_consumption(facility, year)
		facilities = facilities || Facility.all
		best_average = best_facility_method :energy_consumption, facilities, year
		
		my_facility_results[:values] = calc_quarter_average(my_facility_results[:values])
		best_average[:results][:values] = calc_quarter_average(best_average[:results][:values])

	
		{:my_facility_results => my_facility_results, :best_facility_results => best_average[:results][:values]}
	end

	def self.cleaning_cost_nfa(facility, year)
		h_ec = measurement(facility, RankingFacilities::Application::METRIC_NAMES[:ec], year)
		h_nfa = static_measurement(facility, RankingFacilities::Application::ATTRIBUTES_NAMES[:nfa], year, h_ec[:year], h_ec[:lastyear], h_ec[:month_per_year])
		
		array = []
		i=0
		while i < h_ec[:value].size do
			array << (h_ec[:value][i].to_f / h_nfa[:value][i].to_f ).round(2)
			i = i + 1
		end

		{:values => array, :name => RankingFacilities::Application::KPI_NAMES[:ec_nfa], :facility_name => facility.name ,
			:type => RankingFacilities::Application::KPI_UNITS[:ec_nfa], :x => :ec, :y => :nfa, :year => h_ec[:year]}
	end

	def self.cleaning_cost_nfa(facility, year, facilities)
		year = specify_year year
		my_facility_results=energy_consumption(facility, year)
		facilities = facilities || Facility.all
		best_average = best_facility_method :energy_consumption, facilities, year
		
		my_facility_results[:values] = calc_quarter_average(my_facility_results[:values])
		best_average[:results][:values] = calc_quarter_average(best_average[:results][:values])

	
		{:my_facility_results => my_facility_results, :best_facility_results => best_average[:results][:values]}
	end

	def self.cleaning_cost_nfa (facility, year)
		h_tcc = measurement(facility, RankingFacilities::Application::METRIC_NAMES[:tcc], year)
		h_nfa = static_measurement(facility, RankingFacilities::Application::ATTRIBUTES_NAMES[:nfa], year, h_tcc[:year], h_tcc[:lastyear], h_tcc[:month_per_year])
		
		array = []
		i=0
		if h_nfa[:value].size>0
			while i < h_tcc[:value].size do
				array << (h_tcc[:value][i].to_f / h_nfa[:value][i].to_f).round(4) 
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
		best_average = best_facility_method :cleaning_cost_nfa, facilities, year
		
		my_facility_results[:values] = calc_quarter_average(my_facility_results[:values])
		best_average[:results][:values] = calc_quarter_average(best_average[:results][:values])

	
		{:my_facility_results => my_facility_results, :best_facility_results => best_average[:results][:values]}
	end

	def self.space_cost_nfa (facility, year)
		h_tsc = measurement(facility, RankingFacilities::Application::METRIC_NAMES[:tsc], year)
		h_nfa = static_measurement(facility, RankingFacilities::Application::ATTRIBUTES_NAMES[:nfa], year, h_tsc[:year], h_tsc[:lastyear], h_tsc[:month_per_year])
		
		array = []
		i=0
		if h_nfa[:value].size>0
			while i < h_tsc[:value].size do
				array << (h_tsc[:value][i].to_f / h_nfa[:value][i].to_f).round(4) 
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
		best_average = best_facility_method :space_cost_nfa, facilities, year
		
		my_facility_results[:values] = calc_quarter_average(my_facility_results[:values])
		best_average[:results][:values] = calc_quarter_average(best_average[:results][:values])

	
		{:my_facility_results => my_facility_results, :best_facility_results => best_average[:results][:values]}
	end

	def self.occupancy_cost_nfa (facility, year)
		h_toc = measurement(facility, RankingFacilities::Application::METRIC_NAMES[:toc], year)
		h_nfa = static_measurement(facility, RankingFacilities::Application::ATTRIBUTES_NAMES[:nfa], year, h_toc[:year], h_toc[:lastyear], h_toc[:month_per_year])
		
		array = []
		i=0

		if h_nfa[:value].size>0
			while i < h_toc[:value].size do
				array << (h_toc[:value][i].to_f / h_nfa[:value][i].to_f).round(4) 
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

        best_average = best_facility_method :occupancy_cost_nfa, facilities, year
		
		my_facility_results[:values] = calc_quarter_average(my_facility_results[:values])
		best_average[:results][:values] = calc_quarter_average(best_average[:results][:values])

		{:my_facility_results => my_facility_results, :best_facility_results => best_average[:results][:values]}
	end

	#substituir por cleaning, space e occupancy costs
	def self.costs_year facility
		year = Date.current.year
		hash = {:first => {:name => year-2, :values => [avg(cleaning_cost_nfa(facility, (year-2).to_s)[:values]).round(2), avg(space_cost_nfa(facility, (year-2).to_s)[:values]).round(2), avg(occupancy_cost_nfa(facility, (year-2).to_s)[:values]).round(2) ]}}
		hash[:second]={:name => year-1, :values => [avg(cleaning_cost_nfa(facility, (year-1).to_s)[:values]).round(2), avg(space_cost_nfa(facility, (year-1).to_s)[:values]).round(2), avg(occupancy_cost_nfa(facility, (year-1).to_s)[:values]).round(2) ]}
		hash[:third]={:name => year, :values => [avg(cleaning_cost_nfa(facility, year.to_s)[:values]).round(2), avg(space_cost_nfa(facility, year.to_s)[:values]).round(2), avg(occupancy_cost_nfa(facility, year.to_s)[:values]).round(2) ]}
		hash[:categories] = ["Cleaning", "Space", "Occupancy"]
		hash[:graph_name] = 'Cost per NFA'
		hash
	end



end