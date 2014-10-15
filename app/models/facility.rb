class Facility < ActiveRecord::Base
	belongs_to :user  
	has_many :measures
	has_one :site
	has_one :address
end
