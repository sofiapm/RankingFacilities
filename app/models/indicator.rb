class Indicator < ActiveRecord::Base
	include Kpi

	belongs_to :facility, class_name: 'Facility', foreign_key: 'facility_id'

end
