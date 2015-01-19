class Facility < ActiveRecord::Base
	# include Kpi

	belongs_to :role, class_name: 'Role', foreign_key: 'role_id'
	has_one :user, :through => :role
	has_many :facility_static_measures, class_name: 'FacilityStaticMeasure', foreign_key: 'facility_id', dependent: :destroy
  has_many :measures, class_name: 'Measure', foreign_key: 'facility_id', dependent: :destroy
	has_one :site
	belongs_to :address, class_name: 'Address', foreign_key: 'address_id', dependent: :destroy

	accepts_nested_attributes_for :address

  validates :name, presence: true
	# accepts_nested_attributes_for :facility_static_measure

	   # def get_address
    #   address || OpendStruct.new city: 'City Unavaylable'
    #  end
     def internal_work_cost year
  		Kpi.internal_work_cost(self, year)
  	end

    def best_internal_work_cost year, facilities
      if facilities.empty?
        raise "There are no facilities to compare your best_internal_work_cost" 
      else
        Kpi.best_internal_work_cost(self, year, facilities)
      end
    end

  	def water_consumption_fte year
  		Kpi.water_consumption_fte(self, year)
  	end

    def best_water_consumption_fte year, facilities
      if facilities.empty?
        raise "There are no facilities to compare your best_water_consumption_fte" 
      else
        Kpi.best_water_consumption_fte(self, year, facilities)
      end
    end

  	def waste_production_fte year
  		Kpi.waste_production_fte(self, year)
  	end

    def best_waste_production_fte year, facilities
      if facilities.empty?
        raise "There are no facilities to compare your best_waste_production_fte" 
      else
        Kpi.best_waste_production_fte(self, year, facilities)
      end
    end

    def costs_year
      Kpi.costs_year(self)
    end

  	def capacity_vs_utilization year
  		Kpi.capacity_vs_utilization(self, year)
   	end

    def best_capacity_vs_utilization year, facilities
      if facilities.empty?
        raise "There are no facilities to compare your best_capacity_vs_utilization" 
      else
        Kpi.best_capacity_vs_utilization(self, year, facilities)
      end
    end

  	def space_experience year
  		Kpi.space_experience(self, year)
  	end

    def best_space_experience year, facilities
      if facilities.empty?
        raise "There are no facilities to compare your best_space_experience" 
      else
        Kpi.best_space_experience(self, year, facilities)
      end
    end

  	def energy_consumption year
  		Kpi.energy_consumption(self, year)
  	end

    def best_energy_consumption year, facilities
      if facilities.empty?
        raise "There are no facilities to compare your best_energy_consumption" 
      else
        Kpi.best_energy_consumption(self, year, facilities)
      end
    end

    def cleaning_cost_nfa year
      Kpi.cleaning_cost_nfa(self, year)
    end

    def best_cleaning_cost_nfa year, facilities
      if facilities.empty?
        raise "There are no facilities to compare your best_cleaning_cost_nfa" 
      else
        Kpi.best_cleaning_cost_nfa(self, year, facilities)
      end
    end

    def space_cost_nfa year
      Kpi.space_cost_nfa(self, year)
    end

    def best_space_cost_nfa year, facilities
      if facilities.empty?
        raise "There are no facilities to compare your best_space_cost_nfa" 
      else
        Kpi.best_space_cost_nfa(self, year, facilities)
      end
    end

    def occupancy_cost_nfa year
      Kpi.occupancy_cost_nfa(self, year)
    end

    def best_occupancy_cost_nfa year, facilities
      if facilities.empty?
        raise "There are no facilities to compare your best_occupancy_cost_nfa" 
      else
        Kpi.best_occupancy_cost_nfa(self, year, facilities)
      end
    end
end
