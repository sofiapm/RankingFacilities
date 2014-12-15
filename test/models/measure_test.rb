require 'test_helper'

class MeasureTest < ActiveSupport::TestCase
  	test "a user should enter a name" do
		measure = Measure.new
		assert !measure.save
		assert !measure.errors[:name].empty?
	end 

	test "a user should enter a name from the list" do
		measure = Measure.new

		measure.name = "Nome Measure"

		assert !measure.save
		assert !measure.errors[:name].empty?
	end 

	test "a user should enter a value" do
		measure = Measure.new
		assert !measure.save
		assert !measure.errors[:value].empty?
	end 
	
	test "a user should enter a start_date" do
		measure = Measure.new
		assert !measure.save
		assert !measure.errors[:start_date].empty?
	end 

	test "a user should enter a end_date" do
		measure = Measure.new
		assert !measure.save
		assert !measure.errors[:end_date].empty?
	end 

	test "start_date should be less than end_date" do
		measure = Measure.new

		measure.start_date = 2014-11-20
		measure.end_date = 2014-10-20

		assert !measure.save
		assert !measure.errors[:start_date].empty?
		assert !measure.errors[:end_date].empty?
	end 
end
