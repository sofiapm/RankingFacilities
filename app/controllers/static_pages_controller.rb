class StaticPagesController < ApplicationController

	def home_page
    	render 'static_pages/home_page'
  	end

	def error_page
    	render 'static_pages/error_page'
  	end 

  	def success_page
    	render 'static_pages/success_page'
  	end 	
end