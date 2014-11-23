class Measure < ActiveRecord::Base

	belongs_to :facility, class_name: 'Facility', foreign_key: 'facility_id'
	has_one :user, :through => :facility

	def self.import(file, facility_id, current_user)
	  spreadsheet = open_spreadsheet(file)
	  header = spreadsheet.row(1)
	  (2..spreadsheet.last_row).each do |i|
	    row = Hash[[header, spreadsheet.row(i)].transpose]
	    measure = find_by_id(row["id"]) || new
	    row["facility_id"]= facility_id
	    row["user_id"]= current_user
	    measure.attributes = row.to_hash.slice(*Measure.attribute_names())
	    measure.save!
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
