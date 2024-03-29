module DefineGranularMeasure

	def self.add_granular_measure measure
		id_measure = measure.id
		start_date = measure.start_date.to_date
		end_date = measure.end_date.to_date
		value = measure.value.to_f

		avg_value_per_day = average_value_per_day(value, number_of_days(start_date, end_date))
		date = start_date
		while date <= start_date.end_of_month() do
			GranularMeasure.new({day: date.to_s, measure_id: id_measure.to_s, value: avg_value_per_day.to_s}).save
			
			date=date+1
		end
		
		date = end_date.beginning_of_month() 
		while date <= end_date do
			GranularMeasure.new({day: date.to_s, measure_id: id_measure.to_s, value: avg_value_per_day.to_s}).save
			
			date=date+1
		end
	end

	def self.number_of_days start_date, end_date
		end_date - start_date
	end

	def self.average_value_per_day value, number_of_days
		value/number_of_days
	end
end