module Kpi

	def self.measures_output facility
		measures = facility.measures.sort_by{|vn| vn[:date]}
		final=[]
		RankingFacilities::Application::METRIC_NAMES.each do |mn|
			array = []
			measures.each do |m|
				if m.name.to_sym == mn[0]
					array << m.value
				end
			end
			final << {:values => array, :name => mn[1]}
		end
		return final
	end

	def self.measurement(facility, nome_measure)
		measures = facility.measures.sort_by{|vn| vn[:date]}
		array = []
		measures.each do |m|
			if m.name.to_s == nome_measure
				array << m.value
			end
		end
		array
	end

	def self.static_measurement(facility, nome_measure)
		measures = FacilityStaticMeasure.where(facility_id: facility.id).sort_by{|vn| vn[:date]}
		array = []
		measures.each do |m|
			if m.name.to_s == nome_measure
				array << m.value
			end
		end
		array
	end

	def self.internal_work_cost facility
		h_tlc = measurement(facility, RankingFacilities::Application::METRIC_NAMES[:tlc])
		h_ae = measurement(facility, RankingFacilities::Application::METRIC_NAMES[:ae])
		array = []
		i=0
		while i < h_tlc.size do
			array << (h_tlc[i].to_f / h_ae[i].to_f ) *100
			i = i + 1
		end

		{:values => array, :name => RankingFacilities::Application::KPI_NAMES[:iwc], :facility_name => facility.name ,
			:type => RankingFacilities::Application::KPI_UNITS[:iwc], :x => :tlc, :y => :ae}
	end

	def self.water_consumption_fte facility
		h_wc = measurement(facility, RankingFacilities::Application::METRIC_NAMES[:wc])
		h_fte = measurement(facility, RankingFacilities::Application::METRIC_NAMES[:fte])
		array = []
		i=0
		while i < h_wc.size do
			array << h_wc[i].to_f / h_fte[i].to_f 
			i = i + 1
		end

		{:values => array, :name => RankingFacilities::Application::KPI_NAMES[:wc_fte], :facility_name => facility.name ,
			:type => RankingFacilities::Application::KPI_UNITS[:wc_fte], :x => :wc, :y => :fte}
	end

	def self.waste_production_fte facility
		h_wp = measurement(facility, RankingFacilities::Application::METRIC_NAMES[:wp])
		h_fte = measurement(facility, RankingFacilities::Application::METRIC_NAMES[:fte])
		array = []
		i=0
		while i < h_wp.size do
			array << h_wp[i].to_f / h_fte[i].to_f 
			i = i + 1
		end

		{:values => array, :name => RankingFacilities::Application::KPI_NAMES[:wp_fte], :facility_name => facility.name ,
			:type => RankingFacilities::Application::KPI_UNITS[:wp_fte], :x => :wp, :y => :fte}
	end

	def self.capacity_vs_utilization facility
		h_nfa = static_measurement(facility, RankingFacilities::Application::ATTRIBUTES_NAMES[:nfa])
		h_fte = measurement(facility, RankingFacilities::Application::METRIC_NAMES[:fte])
		array = []
		i=0
		while i < h_fte.size do
			array << h_nfa[0].to_f / h_fte[i].to_f 
			i = i + 1
		end

		{:values => array, :name => RankingFacilities::Application::KPI_NAMES[:cu], :facility_name => facility.name ,
			:type => RankingFacilities::Application::KPI_UNITS[:cu], :x => :nfa, :y => :fte}
	end

	def self.space_experience facility
		h_nfa = static_measurement(facility, RankingFacilities::Application::ATTRIBUTES_NAMES[:nfa])
		h_pa = static_measurement(facility, RankingFacilities::Application::ATTRIBUTES_NAMES[:pa])
		array = []
		i=0
		while i < h_nfa.size do
			array << (h_nfa[i].to_f / h_pa[i].to_f)*100 
			i = i + 1
		end

		{:values => array, :name => RankingFacilities::Application::KPI_NAMES[:se], :facility_name => facility.name ,
			:type => RankingFacilities::Application::KPI_UNITS[:se], :x => :pa, :y => :nfa}
	end

	def self.energy_consumption facility
		h_nfa = static_measurement(facility, RankingFacilities::Application::ATTRIBUTES_NAMES[:nfa])
		h_ec = measurement(facility, RankingFacilities::Application::METRIC_NAMES[:ec])
		array = []
		i=0
		while i < h_ec.size do
			array << h_ec[i].to_f / h_nfa[0].to_f 
			i = i + 1
		end

		{:values => array, :name => RankingFacilities::Application::KPI_NAMES[:ec_nfa], :facility_name => facility.name ,
			:type => RankingFacilities::Application::KPI_UNITS[:ec_nfa], :x => :ec, :y => :nfa}
	end

	# def self.line_column_chart facility *arg


	# end

	#Antigos---------
	# def self.cleaning_cost facility
	# 	h_tcc = measurement(facility, :totalcleaningcost)
	# 	h_nfa = measurement(facility, :netfloorarea)
	# 	array = []
	# 	i=0
	# 	while i < h_tcc.size do
	# 		array << h_tcc[i].to_f / h_nfa[i].to_f
	# 		i = i + 1
	# 	end

	# 	{:values => array, :name => "Cleaning Cost per Square Meter", :type =>"€/m^2"}
	# end

	# def self.space_cost facility
	# 	h_tsc = measurement(facility, :totalspacecost)
	# 	h_nfa = measurement(facility, :netfloorarea)
	# 	array = []
	# 	i=0
	# 	while i < h_tsc.size do
	# 		array << h_tsc[i].to_f / h_nfa[i].to_f
	# 		i = i + 1
	# 	end

	# 	{:values => array, :name => "Space Cost per Square Meter", :type =>"€/m^2"}
	# end

	# def self.occupancy_cost facility
	# 	h_toc = measurement(facility, :totaloccupancycost)
	# 	h_nfa = measurement(facility, :netfloorarea)
	# 	array = []
	# 	i=0
	# 	while i < h_toc.size do
	# 		array << h_toc[i].to_f / h_nfa[i].to_f
	# 		i = i + 1
	# 	end

	# 	{:values => array, :name => "Occupancy Cost", :type =>"€/m^2"}
	# end

	# def self.percentage_nfa facility
	# 	h_tla = measurement(facility, :totallevelarea)
	# 	h_nfa = measurement(facility, :netfloorarea)
	# 	array = []
	# 	i=0
	# 	while i < h_tla.size do
	# 		array <<  (h_nfa[i].to_f/h_tla[i].to_f)*100
	# 		i = i + 1
	# 	end

	# 	{:values => array, :name => "Percentage Net Floor Area", :type =>"%"}
	# end

	# def self.percentage_gfa facility
	# 	h_tla = measurement(facility, :totallevelarea)
	# 	h_gfa = measurement(facility, :grossfloorarea)
	# 	array = []
	# 	i=0
	# 	while i < h_tla.size do
	# 		array <<  (h_gfa[i].to_f/h_tla[i].to_f)*100
	# 		i = i + 1
	# 	end

	# 	{:values => array, :name => "Percentage Gross Floor Area", :type =>"%"}
	# end

	# def self.repairs_maintenance facility
	# 	h_ncm = measurement(facility, :numberofcorrectivemaintenance)
	# 	h_npm = measurement(facility, :numberofpreventivemaintenance)
	# 	array = []
	# 	i=0
	# 	while i < h_ncm.size do
	# 		array <<  (h_ncm[i].to_f/h_npm[i].to_f)*100
	# 		i = i + 1
	# 	end

	# 	{:values => array, :name => "Repairs VS Preventive Maintenance", :type =>"%"}
	# end

	# def self.percentage_ac facility
	# 	h_ac = measurement(facility, :areacleaned)
	# 	h_nfa = measurement(facility, :netfloorarea)
	# 	array = []
	# 	i=0
	# 	while i < h_ac.size do
	# 		array <<  (h_ac[i].to_f/h_tla[i].to_f)*100
	# 		i = i + 1
	# 	end

	# 	{:values => array, :name => "Percentage of Area Cleaned", :type =>"%"}
	# end

	# def self.absenteeism facility
	# 	h_tdl = measurement(facility, :totaldayslost)
	# 	h_tpdw = measurement(facility, :totalpossibledaysworked)
	# 	array = []
	# 	i=0
	# 	while i < h_tdl.size do
	# 		array <<  (h_tdl[i].to_f/h_tpdw[i].to_f)*100
	# 		i = i + 1
	# 	end

	# 	{:values => array, :name => "Absenteeism", :type =>"%"}
	# end

	# def self.total_energy_consumption facility
	# 	h_tec = measurement(facility, :totalenergyconsumption)

	# 	{:values => h_tec, :name => "Total Energy Consumption", :type =>"kWh"}
	# end

	# def self.total_water_usage facility
	# 	h_twu = measurement(facility, :totalwaterusage)


	# 	{:values => h_twu, :name => "Total Water Usage", :type =>"m^3"}
	# end

end