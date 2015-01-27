require 'test_helper'

class UserTest < ActiveSupport::TestCase
  	test "a user should enter a first name" do
		user = User.new
		assert !user.save
		assert !user.errors[:first_name].empty?
	end 

	test "a user should enter a last name" do
		user = User.new
		assert !user.save
		assert !user.errors[:last_name].empty?
	end 

	test "a user should enter an email" do
		user = User.new
		assert !user.save
		assert !user.errors[:email].empty?
	end 

	test "a user should have an unique email" do
		user = User.new
		user.email = users(:jane).email

		assert !user.save
		puts user.errors.inspect
		assert !user.errors[:email].empty?
	end 
	
end
