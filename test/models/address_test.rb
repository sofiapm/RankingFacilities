require 'test_helper'

class AddressTest < ActiveSupport::TestCase
	test "a user should enter a street" do
		address = Address.new
		assert !address.save
		assert !address.errors[:street].empty?
	end 

	test "a user should enter a city" do
		address = Address.new
		assert !address.save
		assert !address.errors[:city].empty?
	end 

	test "a user should enter a country" do
		address = Address.new
		assert !address.save
		assert !address.errors[:country].empty?
	end 

	test "a user should enter a zip_code" do
		address = Address.new
		assert !address.save
		assert !address.errors[:zip_code].empty?
	end 
end
