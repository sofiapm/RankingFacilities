class Facility < ActiveRecord::Base
	belongs_to :user, class_name: 'User', foreign_key: 'user_id'
	has_many :measures, class_name: 'Measure', foreign_key: 'facility_id', dependent: :destroy
	has_one :site
	belongs_to :address, class_name: 'Address', foreign_key: 'address_id'
end
