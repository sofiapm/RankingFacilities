module AuxiliarKpiCalc

	def self.calc_quarter_average results
    
      if results.size>0
        result_by_quarter=results.in_groups(4, 0)
        avg_by_quarter = []

        result_by_quarter.each do |r|
          if r
            avg_by_quarter << r.sum / r.size.to_f
          else
            avg_by_quarter << 0
          end
        end
      else
        
        avg_by_quarter=[]
      end
      avg_by_quarter
    end

    def self.avg array
      if array.size > 0
        average = array.sum / array.size.to_f
      else 
        average = 0
      end
    end

    def self.specify_year year
      
      if year == '' or !year
        year = Date.current.year
      end
      
      year
      
    end

    #recebe um array com um valor de medida por cada dia e soma-os para ter o valor do mês
	def self.get_month_value array
		value = 0
		array.each do |a|
			value = value + a.value
		end
		value
	end

end