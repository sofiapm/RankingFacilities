class Address < ActiveRecord::Base
	has_one :facility
	has_one :user

	validates :zip_code, length: { is: 4 }
end
