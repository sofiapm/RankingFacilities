class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

    include RoleModel
    
  	has_many :facilities, class_name: 'Facility', foreign_key: 'user_id', dependent: :destroy 
	has_many :measures, :through => :facility
	belongs_to :address, class_name: 'Address', foreign_key: 'address_id'

	accepts_nested_attributes_for :address
	
	ROLES = %w[admin occupant owner facility_manager service_operator]

	def full_name
		first_name + " " + last_name
	end

	def roles=(roles)
	  self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.inject(0, :+)
	end

	def roles
	  ROLES.reject do |r|
	    ((roles_mask.to_i || 0) & 2**ROLES.index(r)).zero?
	  end
	end

	def is?(role)
	  roles.include?(role.to_s)
	end
end


 
  