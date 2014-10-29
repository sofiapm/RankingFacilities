class Facility < ActiveRecord::Base

	belongs_to :role, class_name: 'Role', foreign_key: 'role_id'
	has_many :measures, class_name: 'Measure', foreign_key: 'facility_id', dependent: :destroy
	has_one :site
	belongs_to :address, class_name: 'Address', foreign_key: 'address_id'

	accepts_nested_attributes_for :address
end
