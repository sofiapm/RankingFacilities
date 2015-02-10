class FacilitiesController < ApplicationController
  before_filter :require_login, :authenticate
  before_action :set_facility, only: [:show, :edit, :update, :destroy]


  # GET /facilities
  # GET /facilities.json
  def index
    @facilities = Role.find(current_user.current_role).facilities
  end

  # GET /facilities/1
  # GET /facilities/1.json
  # def show
  # end

  # GET /facilities/new
  def new
    @facility = Facility.new
    @facility.build_address
    @role = Role.find(current_user.current_role)
  end

  # GET /facilities/1/edit
  def edit
  end

  # POST /facilities
  # POST /facilities.json
  def create
    @facility = Facility.new(facility_params)
    # service = Measure.new
    # service.subscribe(@facility, async: :true)

    # service.on(:import_finished) { |facility, date_created_at| CalculateIndicators.calculate_indicators(facility, date_created_at) }
    # service.on(:added_measure) { |facility, date_created_at| CalculateIndicators.calculate_indicators(facility, date_created_at) }

    # service.execute(:nothing, 0, 0)
    respond_to do |format|
      if @facility.save

        format.html { redirect_to edit_facility_path(@facility), notice: 'Facility was successfully created.' }
        format.json { render :edit, status: :created, location: @facility }
      else
        format.html { render :new }
        format.json { render json: @facility.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /facilities/1
  # PATCH/PUT /facilities/1.json
  def update
    respond_to do |format|
      if @facility.update(facility_params)
        format.html { redirect_to edit_facility_path(@facility), notice: 'Facility was successfully updated.' }
        format.json { render :edit, status: :ok, location: @facility }
      else
        format.html { render :edit }
        format.json { render json: @facility.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /facilities/1
  # DELETE /facilities/1.json
  def destroy
    @facility.destroy
    respond_to do |format|
      format.html { redirect_to success_page_url, notice: 'Facility was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_facility
      @facility = Facility.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def facility_params
      params.require(:facility).permit(:name, :role_id, :user_id, 
        address_attributes: [:street, :city, :country, :zip_code])
        # facility_static_measure_attributes: [:name, :value, :start_date, :end_date, :user_id, :facility_id])
    end

    def authenticate
      if params['id']
        unless current_user.id == Facility.find(params['id'].to_i).user.id 
          authenticate_app
        end
      end
      if params['role_id'] && Role.find(params['role_id']).facilities.first
        unless current_user.id == Role.find(params['role_id']).facilities.first.user.id
              authenticate_app
        end
      end
    end
end
