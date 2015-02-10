class Facility < ActiveRecord::Base
	# include Kpi
  include CalculateIndicators
  include AuxiliarKpiCalc
  # include Wisper

	belongs_to :role, class_name: 'Role', foreign_key: 'role_id'
	has_one :user, :through => :role
	has_many :facility_static_measures, class_name: 'FacilityStaticMeasure', foreign_key: 'facility_id', dependent: :destroy
  has_many :indicators, class_name: 'Indicators', foreign_key: 'facility_id', dependent: :destroy
  has_many :measures, class_name: 'Measure', foreign_key: 'facility_id', dependent: :destroy
	has_one :site
	belongs_to :address, class_name: 'Address', foreign_key: 'address_id', dependent: :destroy

	accepts_nested_attributes_for :address

  validates :name, presence: true
	# accepts_nested_attributes_for :facility_static_measure

    def kpi_query nome, facility, year
      unless !year || year == ""
        #se o ano tiver sido especificado no search
        indicators = Indicator.where("name = ? AND facility_id = ? AND extract(year from date) = ?", RankingFacilities::Application::KPI_NAMES[nome], facility.id, year.to_i.to_s).sort_by{|vn| vn[:date]}
      else
        #se não o ano não tiver sido especificado no search
        indicators = Indicator.where("name = ? AND facility_id = ?", RankingFacilities::Application::KPI_NAMES[nome], facility.id).sort_by{|vn| vn[:date]}
        year=indicators.first.date.year
      end
      array = []
      indicators.each do |i|
        if i.value.to_s != "Infinity"
          array << i.value 
        else
          array << 0
        end
      end
     
      {:values => array, :name => RankingFacilities::Application::KPI_NAMES[nome], :facility_name => facility.name ,
      :type => RankingFacilities::Application::KPI_UNITS[nome], :x => :tlc, :y => :ae, :year => year}
    end


    # verifica qual a facility com melhores resultados de um determinado KPI
    def best_facility_method nome, facilities, year
      best_average = {}
      facilities.each do |f|

        results = kpi_query(nome, f, year)
 
        average = AuxiliarKpiCalc.avg results[:values]
        
        unless best_average[:average]
          best_average = {:results => results, :average => average}
        else 
          if average and average < best_average[:average] and results[:values] != [] #se der NaN, entao da menor..
            best_average = {:results => results, :average => average}
          end
        end
      end
      
      best_average
    end

    def best_kpi_query(nome, year, facilities)
        year = AuxiliarKpiCalc.specify_year year
        my_facility_results=kpi_query(nome, self, year)
        facilities = facilities || Facility.all
        best_average = best_facility_method nome, facilities, year
        
        my_facility_results[:values] = AuxiliarKpiCalc.calc_quarter_average(my_facility_results[:values])
        best_average[:results][:values] = AuxiliarKpiCalc.calc_quarter_average(best_average[:results][:values])
        
       
      
        {:my_facility_results => my_facility_results, :best_facility_results => best_average[:results][:values]}
    end

    def costs_year
      year = Date.current.year
      hash = {:first => {:name => year-2, :values => [AuxiliarKpiCalc.avg(kpi_query(:cc_nfa, self, (year-2).to_s)[:values]).round(2), AuxiliarKpiCalc.avg(kpi_query(:sc_nfa, self, (year-2).to_s)[:values]).round(2), AuxiliarKpiCalc.avg(kpi_query(:oc_nfa, self, (year-2).to_s)[:values]).round(2) ]}}
      hash[:second]={:name => year-1, :values => [AuxiliarKpiCalc.avg(kpi_query(:cc_nfa, self, (year-1).to_s)[:values]).round(2), AuxiliarKpiCalc.avg(kpi_query(:sc_nfa, self, (year-1).to_s)[:values]).round(2), AuxiliarKpiCalc.avg(kpi_query(:oc_nfa, self, (year-1).to_s)[:values]).round(2) ]}
      hash[:third]={:name => year, :values => [AuxiliarKpiCalc.avg(kpi_query(:cc_nfa, self, year.to_s)[:values]).round(2), AuxiliarKpiCalc.avg(kpi_query(:sc_nfa, self, year.to_s)[:values]).round(2), AuxiliarKpiCalc.avg(kpi_query(:oc_nfa, self, year.to_s)[:values]).round(2) ]}
      hash[:categories] = ["Cleaning", "Space", "Occupancy"]
      hash[:graph_name] = 'Cost per NFA'
      hash
    end

    def calculate_indicators facility, created_at
      if facility.id == self.id
        CalculateIndicators.calculate_indicators(facility, created_at)
      end
    end
end
