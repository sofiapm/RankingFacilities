class MeasuresController < ApplicationController
  before_filter :require_login, :authenticate
  before_action :set_measure, only: [:show, :edit, :update, :destroy]

  # GET /measures
  # GET /measures.json
  def index
    @measures = Measure.all
  end

  # GET /measures/1
  # GET /measures/1.json
  def show
  end

  # GET /measures/new
  def new
    @measure = Measure.new
  end

  # GET /measures/1/edit
  def edit
  end

  # POST /measures
  # POST /measures.json
  def create
    @measure = Measure.new(measure_params)

    respond_to do |format|
      if @measure.save
        format.html { redirect_to edit_measure_path(@measure), notice: 'Measure was successfully created.' }
        format.json { render :edit, status: :created, location: @measure }
      else
        format.html { render :new }
        format.json { render json: @measure.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /measures/1
  # PATCH/PUT /measures/1.json
  def update
    respond_to do |format|
      if @measure.update(measure_params)
        format.html { redirect_to edit_measure_path(@measure), notice: 'Measure was successfully updated.' }
        format.json { render :edit, status: :ok, location: @measure }
      else
        format.html { render :edit }
        format.json { render json: @measure.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /measures/1
  # DELETE /measures/1.json
  def destroy
    @measure.destroy
    respond_to do |format|
      format.html { redirect_to measures_url, notice: 'Measure was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_measure
      @measure = Measure.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def measure_params
      params.require(:measure).permit(:name, :value, :start_date, :end_date, :unit, :user_id, :facility_id)
    end

    def authenticate
      # if params['id']
      #   unless current_user.id == Measure.find(params['id'].to_i).user.id 
      #     authenticate_app
      #   end
      # end
      # if params['organization_id'] && Organization.find(params['organization_id']).measures.first
      #   unless current_user.id == Organization.find(params['organization_id']).measures.first.user.id
      #         authenticate_app
      #   end
      # end
    end
end
