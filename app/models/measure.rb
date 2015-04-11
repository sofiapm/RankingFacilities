class Measure < ActiveRecord::Base
	include DefineGranularMeasure
	# include Wisper::Publisher
	belongs_to :facility, class_name: 'Facility', foreign_key: 'facility_id'
	has_one :user, :through => :facility
	has_many :granular_measures, class_name: 'GranularMeasure', foreign_key: 'measure_id', dependent: :destroy
	# has_and_belongs_to_many :indicators, class_name: 'Indicator', foreign_key: 'measure_id', dependent: :destroy
	# has_and_belongs_to_many :indicators
	
	validates :name, presence: true
	validates :value, presence: true
	validates :start_date, presence: true
	validates :end_date, presence: true

	def self.import(file, facility_id, current_user)
	  spreadsheet = open_spreadsheet(file)
	  header = spreadsheet.row(1)
	  date_created_at = Date.new
	  (2..spreadsheet.last_row).each do |i|
	    row = Hash[[header, spreadsheet.row(i)].transpose]
		if !row["name"] or !RankingFacilities::Application::METRIC_NAMES.inject([]){|acum, (key, value) | acum << value }.include? row["name"]
			raise "You have empty or not valid values on 'name' column: " +  row["name"]
		elsif !row["value"] or !row["value"].is_a? Float
			raise "You have empty or not valid values on 'value' column: "
		elsif !row["start_date"] or !row["start_date"].is_a? Date
			raise "You have empty or not valid values on 'start_date' column."
		elsif !row["end_date"] or !row["end_date"].is_a? Date
			raise "You have empty or not valid values on 'end_date' column."
		end
			  	  
	    measure = find_by_id(row["id"]) || new
	    row["facility_id"]= facility_id
	    row["user_id"]= current_user
	    # {"id"=>nil, "name"=>"Total Labour Costs", "value"=>12.0, "start_date"=>Thu, 11 Oct 2012, "end_date"=>Sat, 10 Nov 2012,  "facility_id"=>5, "user_id"=>1, "created_at"=>nil, "updated_at"=>nil}
	    measure.attributes = row.to_hash.slice(*Measure.attribute_names()) 
	    measure.save!
	    DefineGranularMeasure.add_granular_measure(measure)
	    date_created_at=measure.created_at
	  end
	  facility = Facility.find_by_id(facility_id)
	  # execute(:import_finished, facility, date_created_at)
	  CalculateIndicators.calculate_indicators(facility, date_created_at)

	end

	def self.open_spreadsheet(file)
		if(file)
		  case File.extname(file.original_filename)
		  when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
		  when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
		  when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
		  else raise "Unknown file type: #{file.original_filename}"
		  end
		else raise "Please select a file to import."
		end
	end


	# def self.execute(message, facility, date_created_at)
	# 	unless message == :nothing
	# 	Wisper::Publisher.broadcast(message, facility, date_created_at)
	# 	end
	# end

end
