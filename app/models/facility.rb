class Facility < ActiveRecord::Base
	# include Kpi

	belongs_to :role, class_name: 'Role', foreign_key: 'role_id'
	has_one :user, :through => :role
	has_many :measures, class_name: 'Measure', foreign_key: 'facility_id', dependent: :destroy
	has_many :facility_static_measures, class_name: 'FacilityStaticMeasures', foreign_key: 'facility_id', dependent: :destroy
	has_one :site
	belongs_to :address, class_name: 'Address', foreign_key: 'address_id'

	accepts_nested_attributes_for :address
	# accepts_nested_attributes_for :facility_static_measure

	def internal_work_cost
  		Kpi.internal_work_cost self
  	end

  	def water_consumption_fte
  		Kpi.water_consumption_fte self
  	end

  	def waste_production_fte
  		Kpi.waste_production_fte self
  	end

  	def capacity_vs_utilization
  		Kpi.capacity_vs_utilization self
  	end
  	def space_experience
  		Kpi.space_experience self
  	end
  	def energy_consumption
  		Kpi.energy_consumption self
  	end
end
