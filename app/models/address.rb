class Address < ActiveRecord::Base

	has_one :facility, class_name: 'Facility', foreign_key: 'address_id'
	has_one :user, class_name: 'User', foreign_key: 'address_id'

	validates :zip_code, length: { is: 4 }
end
