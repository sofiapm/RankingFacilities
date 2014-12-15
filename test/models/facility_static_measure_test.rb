require 'test_helper'

class FacilityStaticMeasureTest < ActiveSupport::TestCase
  # RankingFacilities::Application::METRIC_NAMES.inject([]){|acum, (key, value) | acum << value }

  	test "a user should enter a name" do
		static_measure = FacilityStaticMeasure.new
		assert !static_measure.save
		assert !static_measure.errors[:name].empty?
	end 

	test "a user should enter a name from the list" do
		static_measure = FacilityStaticMeasure.new

		static_measure.name = "Static Measure Name"

		assert !static_measure.save
		assert !static_measure.errors[:name].empty?
	end 

	test "a user should enter a value" do
		static_measure = FacilityStaticMeasure.new
		assert !static_measure.save
		assert !static_measure.errors[:value].empty?
	end 
	
	test "a user should enter a start_date" do
		static_measure = FacilityStaticMeasure.new
		assert !static_measure.save
		assert !static_measure.errors[:start_date].empty?
	end 

	test "a user should enter a end_date" do
		static_measure = FacilityStaticMeasure.new
		assert !static_measure.save
		assert !static_measure.errors[:end_date].empty?
	end 

	test "start_date should be less than end_date" do
		static_measure = FacilityStaticMeasure.new

		static_measure.start_date = 2014-11-20
		static_measure.end_date = 2014-10-20

		assert !static_measure.save
		assert !static_measure.errors[:start_date].empty?
		assert !static_measure.errors[:end_date].empty?
	end 
end
