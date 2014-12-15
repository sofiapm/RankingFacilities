class Role < ActiveRecord::Base

	has_many :facilities, class_name: 'Facility', foreign_key: 'role_id', dependent: :destroy 
	belongs_to :user, class_name: 'User', foreign_key: 'user_id'

	validates :name, presence: true
	validates :company_name, presence: true
	validates :nif, presence: true, uniqueness: true
	validates :sector, presence: true

	def has_facilities?
		if self.facilities
			true
		else
			false 
		end
	end
end
