require 'test_helper'

class FacilityTest < ActiveSupport::TestCase
		require 'minitest/autorun'
	require 'pry-rescue/minitest'
  	test "a user should enter a name" do
		facility = Facility.new
		assert !facility.save
		assert !facility.errors[:name].empty?
	end 
end
