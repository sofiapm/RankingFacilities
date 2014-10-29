class UserRolesController < ActionController::Base

	def update
    	respond_to do |format|
	      if current_user.update(:current_role => params[:current_role])
	        format.html { redirect_to root_path, notice: 'User was successfully updated.' }
	        format.json { render :edit, status: :ok, location: current_user }
	      else
	        format.html { render :edit }
	        format.json { render json: current_user.errors, status: :unprocessable_entity }
	      end
	    end
	end

end