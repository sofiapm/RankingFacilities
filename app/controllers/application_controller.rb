class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  # rescue_from CanCan::AccessDenied do |exception|
  #   redirect_to root_url, :alert => exception.message
  # end

  #continue to use rescue_from in the same way as before
  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, :with => :render_error
    rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found   
    rescue_from ActionController::RoutingError, :with => :render_not_found
  end 
 
  #called by last route matching unmatched routes.  Raises RoutingError which will be rescued from in the same way as other exceptions.
  # def raise_not_found!
  #   raise ActionController::RoutingError.new("No route matches #{params[:unmatched_route]}")
  #   # redirect_to static_pages_error_you_can_not_access_page_path
  # end
 
  #render 500 error 
  def render_error(e)
    respond_to do |f| 
      f.html{ render :template => "errors/500", :status => 500 }
      f.js{ render :partial => "errors/ajax_500", :status => 500 }
    end
  end
  
  #render 404 error 
  def render_not_found(e)
    respond_to do |f| 
      f.html{ render :template => "errors/404", :status => 404 }
      f.js{ render :partial => "errors/ajax_404", :status => 404 }
    end
  end

  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:current_role, :first_name, :last_name, :nif, :email, :password, :password_confirmation, address_attributes: [:street, :city, :country, :zip_code]) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:current_role, :first_name, :last_name, :nif, :email, :current_password,:password, :password_confirmation, address_attributes: [:street, :city, :country, :zip_code], roles_attributes: [:name, :company_name, :nif, :sector, :id]) }
  end 

  private

  def require_login
    unless logged_in?
      flash[:error] = "You must be logged in to access this section"
      redirect_to error_you_can_not_access_page_path # halts request cycle
    end
  end

  def authenticate_app
    flash[:error] = "You can not access this section"
    redirect_to error_you_can_not_access_page_path # halts request cycle
  end

  def error_add_facility
    flash[:error] = "You need to select a Role"
    redirect_to error_role_empty_page_path # halts request cycle
  end

  # The logged_in? method simply returns true if the user is logged
  # in and false otherwise. It does this by "booleanizing" the
  # current_user method we created previously using a double ! operator.
  # Note that this is not common in Ruby and is discouraged unless you
  # really mean to convert something into true or false.
  def logged_in?
    !!current_user
  end
end
