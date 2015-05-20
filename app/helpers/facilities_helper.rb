module FacilitiesHelper

	def get_classes(params, facility_id)
		if params[:facility_id]==facility_id.to_s || (params[:controller]=="facilities" && params[:id]==facility_id.to_s)
			"active"
		else
			""
		end
	end
end
