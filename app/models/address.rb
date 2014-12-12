class Address < ActiveRecord::Base

	has_one :facility, class_name: 'Facility', foreign_key: 'address_id'
	has_one :user, class_name: 'User', foreign_key: 'address_id'

	validates :city, presence: true
	validates :country, presence: true
	validates :street, presence: true
	validates :zip_code, presence: true, length: { is: 4 }
end
