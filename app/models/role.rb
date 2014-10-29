class Role < ActiveRecord::Base

	has_many :facilities, class_name: 'Facility', foreign_key: 'role_id', dependent: :destroy 
	belongs_to :user, class_name: 'User', foreign_key: 'user_id'

end
