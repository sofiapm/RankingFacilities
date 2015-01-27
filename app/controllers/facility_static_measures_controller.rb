class FacilityStaticMeasuresController < ApplicationController
  before_filter :require_login, :authenticate
  before_action :set_facility_static_measure, only: [:show, :edit, :update, :destroy]

  # GET /facility_static_measures
  # GET /facility_static_measures.json
  def index
    @facility = Facility.find(params[:facility_id])
    @q = FacilityStaticMeasure.where(facility_id: params[:facility_id].to_i).search(params[:q])

    @facility_static_measures =  @q.result(distinct: true)
    # @facility_static_measures = FacilityStaticMeasure.where(facility_id: params[:facility_id].to_i).sort_by{|vn| vn[:date]} #Facility.find(params[:facility_id]).facility_static_measures
    @facility_static_measure = FacilityStaticMeasure.new
       
  end

  # GET /facility_static_measures/1
  # GET /facility_static_measures/1.json
  def show
  end

  # GET /facility_static_measures/new
  def new
    @facility_static_measure = FacilityStaticMeasure.new
    @facility = Facility.find(params[:facility_id])
  end

  # GET /facility_static_measures/1/edit
  def edit
  end

  # POST /facility_static_measures
  # POST /facility_static_measures.json
  def create
    @facility_static_measure = FacilityStaticMeasure.new(facility_static_measure_params)

    respond_to do |format|
      if @facility_static_measure.save
        
        format.html { redirect_to edit_facility_static_measure_path(@facility_static_measure), notice: 'Facility static measure was successfully created.' }
        format.json { render :edit, status: :created, location: @facility_static_measure }
      else
        format.html { render :new }
        format.json { render json: @facility_static_measure.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /facility_static_measures/1
  # PATCH/PUT /facility_static_measures/1.json
  def update
    respond_to do |format|
      if @facility_static_measure.update(facility_static_measure_params)
        format.html { redirect_to edit_facility_static_measure_path(@facility_static_measure), notice: 'Facility static measure was successfully updated.' }
        format.json { render :edit, status: :ok, location: @facility_static_measure }
      else
        format.html { render :edit }
        format.json { render json: @facility_static_measure.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /facility_static_measures/1
  # DELETE /facility_static_measures/1.json
  def destroy
    @facility_id = @facility_static_measure.facility_id
    @facility_static_measure.destroy
    respond_to do |format|
      format.html { redirect_to facility_facility_static_measures_path(@facility_id), notice: 'Facility static measure was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_facility_static_measure
      @facility_static_measure = FacilityStaticMeasure.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def facility_static_measure_params
      params.require(:facility_static_measure).permit(:name, :value, :start_date, :end_date, :facility_id, :user_id)
    end

    def authenticate
      if params[:id]
        unless current_user.id == FacilityStaticMeasure.find(params[:id]).user_id 
          authenticate_app
        end
      end
      if params[:facility_id] && Facility.find(params[:facility_id])
        unless current_user.id == Facility.find(params[:facility_id]).user.id
              authenticate_app
        end
      end
    end
end
