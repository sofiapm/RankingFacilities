class Facility < ActiveRecord::Base
<<<<<<< HEAD
	belongs_to :user, class_name: 'User', foreign_key: 'user_id'
	has_many :measures, class_name: 'Measure', foreign_key: 'facility_id', dependent: :destroy
	has_one :site
	belongs_to :address, class_name: 'Address', foreign_key: 'address_id'
=======
	belongs_to :user  
	has_many :measures
	has_one :site
	has_one :address
>>>>>>> aa89705c01eb0f367142a46015abfef58d59100d
end
