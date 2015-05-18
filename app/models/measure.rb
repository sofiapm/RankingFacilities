class Measure < ActiveRecord::Base
	include DefineGranularMeasure
	belongs_to :facility, class_name: 'Facility', foreign_key: 'facility_id'
	has_one :user, :through => :facility
	has_many :granular_measures, class_name: 'GranularMeasure', foreign_key: 'measure_id', dependent: :destroy

	validates :name, presence: true
	validates :value, presence: true
	validates :start_date, presence: true
	validates :end_date, presence: true

	def self.import(file, facility_id, current_user)
	  spreadsheet = open_spreadsheet(file)
	  header = spreadsheet.row(1)
	  (2..spreadsheet.last_row).each do |i|
	    row = Hash[[header, spreadsheet.row(i)].transpose]
		if !row["name"] or !RankingFacilities::Application::METRIC_NAMES.inject([]){|acum, (key, value) | acum << value }.include? row["name"]
			raise "You have a empty or not valid values on 'name' column: "
		elsif row["value"] and !row["value"].is_a? Float
			raise "You have a  not valid values on 'value' column: "
		elsif row["start_date"] and !row["start_date"].is_a? Date
			raise "You have a  not valid values on 'start_date' column."
		elsif row["end_date"] and !row["end_date"].is_a? Date
			raise "You have a not valid values on 'end_date' column."
		end
			
		unless !row["name"] or !row["value"] or !row["start_date"] or !row["end_date"] 
	    measure = find_by_id(row["id"]) || new
	    row["facility_id"]= facility_id
	    row["user_id"]= current_user
	    measure.attributes = row.to_hash.slice(*Measure.attribute_names())
	    measure.save!
	    DefineGranularMeasure.add_granular_measure(measure)
		end
	  end
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

end
