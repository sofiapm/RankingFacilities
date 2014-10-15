class Address < ActiveRecord::Base
	has_one :facility
	has_one :user
end
