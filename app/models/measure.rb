class Measure < ActiveRecord::Base
	belongs_to :facility
	has_one :user, :through => :facility
end
