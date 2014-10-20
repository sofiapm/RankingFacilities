class Measure < ActiveRecord::Base
<<<<<<< HEAD
	belongs_to :facility, class_name: 'Facility', foreign_key: 'facility_id'
	has_one :user, :through => :facility

=======
	belongs_to :facility
	has_one :user, :through => :facility
>>>>>>> aa89705c01eb0f367142a46015abfef58d59100d
end
