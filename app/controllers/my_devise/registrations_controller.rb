class MyDevise::RegistrationsController < Devise::RegistrationsController

  before_filter :configure_permitted_parameters

  # GET /users/sign_up

  
  def new

    # Override Devise default behaviour and create a profile as well
    build_resource({})
    resource.build_address
    respond_with self.resource
  end

  def edit
  end

  # protected

  # def configure_permitted_parameters
  #   devise_parameter_sanitizer.for(:sign_up) { |u|
  #     u.permit(:email, :password, :password_confirmation, :profile_attributes => :fullname)
  #   }
  # end

end