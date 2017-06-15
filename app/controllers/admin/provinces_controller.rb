class Admin::ProvincesController < Admin::AdminController
  before_action :set_province, only: [:show, :edit, :update, :destroy, :duplicate]

  add_breadcrumb I18n.t(:province_index_title), :admin_provinces_path

  # GET /provinces
  # GET /provinces.json
  def index
    @provinces = Province.search(params[:search]).paginate(page: params[:page])
    @export = Province.all

    respond_to do |format|
      format.html
      format.xlsx {
        response.headers['Content-Disposition'] = 'attachment; filename="Provinces.xlsx"'
      }
    end
  end

  #Import
  def import

    if params[:import].blank?
      redirect_to admin_provinces_path, alert: t(:province_import_error)
    else
    spreadsheet = open_spreadsheet(params[:import][:file])
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      province = Province.new
      province.name = spreadsheet.row(i)[0]
      province.save!
    end
    redirect_to admin_provinces_path, notice: t(:import_success)
     end
  end

  # GET /provinces/1
  # GET /provinces/1.json
  def show
    add_breadcrumb t(:show), :admin_province_path
  end

  # GET /provinces/new
  def new
    add_breadcrumb t(:new), :new_admin_province_path
    @province = Province.new
  end

  # GET /provinces/1/edit
  def edit
    add_breadcrumb t(:edit), :edit_admin_province_path
  end

  # POST /provinces
  # POST /provinces.json
  def create
    @province = Province.new(province_params)

    respond_to do |format|
      if @province.save
        format.html { redirect_to [:admin, @province], notice: t(:created) }
        format.json { render :show, status: :created, location: @province }
      else
        format.html { render :new }
        format.json { render json: @province.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /provinces/1
  # PATCH/PUT /provinces/1.json
  def update
    respond_to do |format|
      if @province.update(province_params)
        format.html { redirect_to [:admin, @province], notice: t(:updated) }
        format.json { render :show, status: :ok, location: @province }
      else
        format.html { render :edit }
        format.json { render json: @province.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /provinces/1
  # DELETE /provinces/1.json
  def destroy
    if (params[:ids] != nil)
      Province.where(id: params[:ids]).destroy_all
    else
      @province.destroy
    end
    respond_to do |format|
      format.html { redirect_to admin_provinces_url, notice: t(:destroyed) }
      format.json { head :no_content }
    end
  end

  def destroy_multiple
    # abort
    if (params[:ids] != nil)
      Province.where(id: params[:ids]).destroy_all
      respond_to do |format|
        format.html { redirect_to admin_provinces_url, notice: t(:destroyed) }
        format.json { head :no_content }
      end
    else
      redirect_to admin_provinces_path, :alert => "Vui lòng chọn ít nhất một phần tử."
    end
  end

  #COPY
  def duplicate
    @province = Province.new(@province.attributes)
    render :new
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_province
      if (params[:ids] == nil)
        if (params[:id] == 'destroy_multiple')
          redirect_to provinces_path, :alert => "Vui lòng chọn ít nhất một phần tử."
        else
          @province = Province.find(params[:id])
        end
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def province_params
      params.require(:province).permit(:name)
    end
end
