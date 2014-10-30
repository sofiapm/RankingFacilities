class RolesController < ApplicationController
  before_filter :require_login
  # , :authenticate
  before_action :set_role, only: [:show, :edit, :update, :destroy]

  ROLES_NAMES = { occupant: 'Occupant', owner: 'Owner', facility_manager: 'Facility Manager', service_operator: 'Service Operator' }
  ROLES_SECTOR = { sector1: 'Sector 1', sector2: 'Sector 2', sector3: 'Sector 3', sector4: 'Sector 4', sector5: 'Sector 5', sector6: 'Sector 6'}

  # GET /roles
  # GET /roles.json
  def index
    @roles = current_user.roles
    @roles_names = ROLES_NAMES
    @roles_sector = ROLES_SECTOR
  end

  # # GET /roles/1
  # # GET /roles/1.json
  # def show
  # end

  # GET /roles/new
  def new
    @role = Role.new
    @roles_names = ROLES_NAMES
    @roles_sector = ROLES_SECTOR
  end

  # GET /roles/1/edit
  def edit
    @roles_names = ROLES_NAMES
    @roles_sector = ROLES_SECTOR
  end

  # POST /roles
  # POST /roles.json
  def create
    @role = Role.new(role_params)

    respond_to do |format|
      if @role.save
        format.html { redirect_to edit_role_path(@role), notice: 'Role was successfully created.' }
        format.json { render :edit, status: :created, location: @role }
      else
        format.html { render :new }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /roles/1
  # PATCH/PUT /roles/1.json
  def update
    respond_to do |format|
      if @role.update(role_params)
        format.html { redirect_to edit_role_path(@role), notice: 'Role was successfully updated.' }
        format.json { render :edit, status: :ok, location: @role }
      else
        format.html { render :edit }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /roles/1
  # DELETE /roles/1.json
  def destroy
    @role.destroy
    respond_to do |format|
      format.html { redirect_to roles_url, notice: 'Role was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_role
      @role = Role.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def role_params
      params.require(:role).permit(:name, :company_name, :nif, :sector, :user_id)
    end

    def authenticate
      if params['id']
        unless current_user.id == Role.find(params['id'].to_i).user_id 
          authenticate_app
        end
      end
    end
end
