class ImporterJob 
  include SuckerPunch::Job
  
  def perform(file, facility_id, user_id)
  	ActiveRecord::Base.connection_pool.with_connection do
  	  Measure.import(file, facility_id, user_id)
  	end
    # raise NotImplementedError
  end
end
