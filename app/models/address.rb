class Address < ActiveRecord::Base
<<<<<<< HEAD
	has_one :facility, class_name: 'Facility', foreign_key: 'address_id'
	has_one :user, class_name: 'User', foreign_key: 'address_id'
=======
	has_one :facility
	has_one :user
>>>>>>> aa89705c01eb0f367142a46015abfef58d59100d

	validates :zip_code, length: { is: 4 }
end
