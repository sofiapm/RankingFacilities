class FacilityStaticMeasure < ActiveRecord::Base
	belongs_to :facility, class_name: 'Facility', foreign_key: 'facility_id'
	has_one :user, :through => :facility

	validates :name, presence: true
	validates :value, presence: true
	validates :start_date, presence: true
	validates :end_date, presence: true
end
