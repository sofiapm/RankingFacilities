class MyDevise::RegistrationsController < Devise::RegistrationsController

  before_filter :configure_permitted_parameters

  ROLES_NAMES = {occupant: "Occupant", owner: "Owner", facility_manager: "Facility Manager", service_operator: "Service Operator" }
  ROLES_SECTOR = { sector1: 'Sector 1', sector2: 'Sector 2', sector3: 'Sector 3', sector4: 'Sector 4', sector5: 'Sector 5', sector6: 'Sector 6'}
  # GET /users/sign_up

  
  def new

    # Override Devise default behaviour and create a profile as well
    build_resource({})
    resource.build_address
    respond_with self.resource
  end

  def edit
       @roles_names = ROLES_NAMES
       @roles_sector = ROLES_SECTOR
  end

  # protected

  # def configure_permitted_parameters
  #   devise_parameter_sanitizer.for(:sign_up) { |u|
  #     u.permit(:email, :password, :password_confirmation, :profile_attributes => :fullname)
  #   }
  # end

end