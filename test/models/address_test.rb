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

	test "a user should enter a zip_code with 4 digits not less" do
		address = Address.new
		address.zip_code = addresses(:joana_less_than_four).zip_code
		assert !address.save
		puts address.errors.inspect
		assert !address.errors[:zip_code].empty?
	end 

	test "a user should enter a zip_code with 4 digits not more" do
		address = Address.new
		address.zip_code = addresses(:joana_great_than_four).zip_code
		assert !address.save
		puts address.errors.inspect
		assert !address.errors[:zip_code].empty?
	end 
end
