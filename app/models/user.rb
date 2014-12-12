class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  	devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

    include RoleModel
    
  	has_many :roles, class_name: 'Role', foreign_key: 'user_id', dependent: :destroy 
  	has_many :facilities, :through => :role
	has_many :measures, :through => :facility
	has_many :facility_static_measures, :through => :facility
	belongs_to :address, class_name: 'Address', foreign_key: 'address_id'

	accepts_nested_attributes_for :address, :roles
	validates :first_name, presence: true
	validates :last_name, presence: true
	validates :email, presence: true

	def full_name
		first_name + " " + last_name

	end

	def not_roles rol 
		rol.find_all do |r|
			!roles.find_by_name(r)
		end
	end
end


 
  