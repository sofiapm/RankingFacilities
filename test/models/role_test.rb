require 'test_helper'

class RoleTest < ActiveSupport::TestCase
	# require 'minitest/autorun'
	# require 'pry-rescue/minitest'

  	test "a user should enter a name for the role" do
		role = Role.new
		assert !role.save
		assert !role.errors[:name].empty?
	end

	test "a user should enter a company_name" do
		role = Role.new
		assert !role.save
		assert !role.errors[:company_name].empty?
	end 

	test "a user should enter a nif" do
		role = Role.new
		assert !role.save
		assert !role.errors[:nif].empty?
	end 

	test "a user should enter a sector" do
		role = Role.new
		assert !role.save
		assert !role.errors[:sector].empty?
	end  

	test "a role should have an unique nif" do
		role = Role.new
		role.nif = roles(:jane_occupant_role).nif

		assert !role.save
		puts role.errors.inspect
		assert !role.errors[:nif].empty?
	end 
end
