class Admin::GroupsController < Admin::AdminController
  before_action :set_group, only: [:show, :edit, :update, :destroy, :duplicate]

  add_breadcrumb I18n.t(:group_index_title), :admin_groups_path
  # GET /groups
  # GET /groups.json
  def index
    # @groups = Group.all
    @groups = Group.search(params[:search]).paginate(page: params[:page])
    @export = Group.all

    respond_to do |format|
      format.html
      format.xlsx {
        response.headers['Content-Disposition'] = 'attachment; filename="groups.xlsx"'
      }
    end
  end

  def import
    if params[:import].blank?
      redirect_to admin_groups_path, alert: t(:import_error)
    else
      spreadsheet = open_spreadsheet(params[:import][:file])
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        group = Group.new
        group.name = spreadsheet.row(i)[0]
        group.description = spreadsheet.row(i)[1]
        group.level = spreadsheet.row(i)[2]
        group.save!
      end
      redirect_to admin_groups_path, notice: t(:import_success)
    end
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    add_breadcrumb t(:show), :admin_group_path
  end

  # GET /groups/new
  def new
    add_breadcrumb t(:new), :new_admin_group_path
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
    add_breadcrumb t(:edit), :edit_admin_group_path
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)

    respond_to do |format|
      if @group.save
        format.html { redirect_to admin_groups_url, notice: t(:group_create_successfull) }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to admin_groups_url, notice: t(:group_update_successfull) }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  # def destroy_multiple
  #   if (params[:ids] != nil)
  #     Group.where(id: params[:ids]).destroy_all
  #     respond_to do |format|
  #       format.html { redirect_to admin_groups_url, notice: t(:group_destroyed_successfull) }
  #       format.json { head :no_content }
  #     end
  #   else
  #     redirect_to admin_groups_path, :alert => t(:delete_mutiple_alert)
  #   end
  # end

  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to admin_groups_url, notice: t(:group_destroyed_successfull) }
      format.json { head :no_content }
    end
  end
# def duplicate
#   @group = Group.new(@group.attributes)
#   render :new
# end

private
# Use callbacks to share common setup or constraints between actions.
def set_group
  if (params[:ids] == nil)
    if (params[:id] == 'destroy_multiple')
      redirect_to groups_path, :alert => "Vui lòng chọn ít nhất một phần tử."
    else
      @group = Group.find(params[:id])
    end
  end
end

# Never trust parameters from the scary internet, only allow the white list through.
def group_params
  params.require(:group).permit(:name, :description, :level)
end

end
