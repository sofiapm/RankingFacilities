class Measure < ActiveRecord::Base

	belongs_to :facility, class_name: 'Facility', foreign_key: 'facility_id'
	has_one :user, :through => :facility

end
