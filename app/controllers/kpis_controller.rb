class KpisController < ApplicationController
  include Kpi
	#before_filter :require_login, :authenticate

	def index
    @facility = Facility.find(params['facility_id'])
    @q = Facility.search(params[:q])
    @all_facilities = @q.result(distinct: true)
	end

	private

	def authenticate
      if params['facility_id']

        unless current_user.id == Facility.find(params['facility_id']).user.id 
          authenticate_app
        end
      else
      	authenticate_app
      end
  end
end