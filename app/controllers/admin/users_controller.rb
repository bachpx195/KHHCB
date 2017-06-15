class Admin::UsersController < Admin::AdminController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :duplicate]

  add_breadcrumb I18n.t(:user_index_title), :admin_users_path

  # GET /users
  # GET /users.json
  def index
    @users = User.search(params[:search]).paginate(page: params[:page])
    @export = User.all

    respond_to do |format|
      format.html
      format.xlsx {
        response.headers['Content-Disposition'] = 'attachment; filename="users.xlsx"'
      }
    end
  end

  def import
    spreadsheet = open_spreadsheet(params[:import][:file])
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      user = User.new
      group = Group.where(name: spreadsheet.row(i)[0]).take
      if !group.nil?
        user.group = group
        user.first_name = spreadsheet.row(i)[1]
        user.last_name = spreadsheet.row(i)[2]
        user.email = spreadsheet.row(i)[3]
        user.avatar = spreadsheet.row(i)[4]
        user.birthday = spreadsheet.row(i)[5]
        user.phone = spreadsheet.row(i)[6]
        user.address = spreadsheet.row(i)[7]
        user.description = spreadsheet.row(i)[8]
        user.website = spreadsheet.row(i)[9]
        user.facebook = spreadsheet.row(i)[10]
        user.organization = spreadsheet.row(i)[11]
        user.actived = spreadsheet.row(i)[12]
        user.password = spreadsheet.row(i)[13]
        user.save!
      else
        redirect_to admin_users_path, notice: t(:missing_value)
        return
      end
    end
    redirect_to admin_users_path, notice: t(:import_success)
  end

  # GET /users/1
  # GET /users/1.json
  def show
    add_breadcrumb t(:show), :admin_user_path
  end

  # GET /users/new
  def new
    add_breadcrumb t(:new), :new_admin_user_path
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    add_breadcrumb t(:edit), :edit_admin_user_path
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to [:admin, @user], notice: t(:created) }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to admin_users_url, notice: t(:updated) }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if @user.cources.length != 0
      respond_to do |format|
        format.html { redirect_to admin_users_url, alert: t(:undestroy_category) }
        format.json { head :no_content }
      end
    else
      @user.destroy
      respond_to do |format|
        format.html { redirect_to admin_users_url, notice: t(:destroyed) }
        format.json { head :no_content }
      end
    end
  end

  def destroy_multiple
    i=0
    users = User.where(id: params[:user_ids])
    if params[:user_ids] == nil
      respond_to do |format|
        format.html { redirect_to admin_users_url, alert: t(:delete_mutiple_alert) }
        format.json { head :no_content }
      end
      return
    end
    users.each do |user|
      break if user.cources.length != 0
      user.destroy
      i+=1
    end
    if i==0
      respond_to do |format|
        format.html { redirect_to admin_users_url, alert: t(:undestroy_category) }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to admin_users_url, notice: t(:destroyed) }
        format.json { head :no_content }
      end
    end


  end

  def duplicate
    @user = User.new(@user.attributes)
    render :new
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    if params[:ids].kind_of?(Array)
      @user = User.where("id" => params[:ids])
    else
      @user = User.find(params[:id])
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:group_id, :first_name, :last_name, :avatar, :birthday, :phone, :address, :description, :website, :facebook, :organization, :actived, :email, :password, :password_confirmed)
  end
end
