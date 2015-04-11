class Indicator < ActiveRecord::Base
	include Kpi

	belongs_to :facility, class_name: 'Facility', foreign_key: 'facility_id'
	# belongs_to :measure, class_name: 'Measure', foreign_key: 'measure_id'
	# has_and_belongs_to_many :measures

end
