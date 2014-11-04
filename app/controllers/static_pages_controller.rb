class StaticPagesController < ApplicationController

	def home_page
    	render 'static_pages/home_page'
  	end

  	def vertical_details
  		cookies[:state] = "details"
  	end

  	def vertical_metrics
  		render 'static_pages/vertical_metrics'
  	end

  	def vertical_indicators
  		render 'static_pages/vertical_indicators'
  	end

	def error_page
    	render 'static_pages/error_page'
  	end 

  	def success_page
    	render 'static_pages/success_page'
  	end 	
end