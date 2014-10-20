class StaticPagesController < ApplicationController

	def home_page
    	render 'static_pages/home_page'
  	end

	def edit_user_organizations
    	render 'static_pages/edit_user_organizations'
  	end  	
end