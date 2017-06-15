class Admin::CourcesController < Admin::AdminController
  include SearchCource
  before_action :set_cource, only: [:show, :edit, :update, :destroy, :duplicate]
  before_action :set_search_cource, only: [:index]
  add_breadcrumb I18n.t(:cource_index_title), :admin_cources_path
  # GET /cources
  # GET /cources.json
  def index
    @export = Cource.all

    respond_to do |format|
      format.html
      format.xlsx {
        response.headers['Content-Disposition'] = 'attachment; filename="cources.xlsx"'
      }
    end
  end

  # GET /cources/1
  # GET /cources/1.json
  def show
    add_breadcrumb t(:show), :admin_cource_path
  end

  # GET /cources/new
  def new
    add_breadcrumb t(:new), :new_admin_cource_path
    @cource = Cource.new
  end

  # GET /cources/1/edit
  def edit
    add_breadcrumb t(:edit), :edit_admin_cource_path
  end

  # POST /cources
  # POST /cources.json
  def create
    @cource = Cource.new(cource_params)


    respond_to do |format|
      if @cource.save
        format.html { redirect_to [:admin, @cource], notice: t(:created) }
        format.json { render :show, status: :created, location: @cource }
      else
        format.html { render :new }
        format.json { render json: @cource.errors, status: :unprocessable_entity }
      end
    end
  end

  def reorder
    @cource = Cource.find(ajax_cource_params[:id])
    @cource.name = ajax_category_params[:name]
    @cource.cource_date = ajax_category_params[:cource_date]
    @cource.address = ajax_category_params[:address]
    @cource.cost_description = ajax_category_params[:cost_description]
    @cource.promotion = ajax_category_params[:promotion]
    @cource.organization_name = ajax_category_params[:organization_name]
    @cource.rate = ajax_category_params[:rate]
    @cource.save!
    render nothing: true # this is a POST action, updates sent via AJAX, no view rendered
  end

  def import
    if params[:import].blank?
      redirect_to admin_cources_path, alert: t(:import_error)
    else
      spreadsheet = open_spreadsheet(params[:import][:file])
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        cource = Cource.new
        category = Category.where(name: spreadsheet.row(i)[0]).take
        user = User.where(email: spreadsheet.row(i)[1]).take
        province = Province.where(name: spreadsheet.row(i)[3]).take
        if !category.nil? && !user.nil? && !province.nil?
          cource.category_id = category.id
          cource.user_id = user.email
          cource.name = spreadsheet.row(i)[2]
          cource.province_id = province.id
          cource.start_date = spreadsheet.row(i)[4]
          cource.schedule = spreadsheet.row(i)[5]
          cource.cource_date = spreadsheet.row(i)[6]
          cource.duration = spreadsheet.row(i)[7]
          cource.end_date = spreadsheet.row(i)[8]
          cource.address = spreadsheet.row(i)[9]
          cource.cost = spreadsheet.row(i)[10]
          cource.cost_description = spreadsheet.row(i)[11]
          cource.promotion = spreadsheet.row(i)[12]
          cource.promotion_description = spreadsheet.row(i)[13]
          #cource.image = spreadsheet.row(i)[14]
          cource.content = spreadsheet.row(i)[15]
          cource.representative = spreadsheet.row(i)[16]
          cource.email = spreadsheet.row(i)[17]
          cource.hotline = spreadsheet.row(i)[18]
          cource.organization_name = spreadsheet.row(i)[19]
          cource.organization_address = spreadsheet.row(i)[20]
          cource.organization_phone = spreadsheet.row(i)[21]
          cource.organization_email = spreadsheet.row(i)[22]
          cource.organization_website = spreadsheet.row(i)[23]
          cource.organization_facebook = spreadsheet.row(i)[24]
          cource.status = spreadsheet.row(i)[25]
          cource.featured = spreadsheet.row(i)[26]
          cource.rate = spreadsheet.row(i)[27]
          cource.save!
        end
      end
      redirect_to admin_cources_path, notice: t(:import_success)
    end
  end

  # PATCH/PUT /cources/1
  # PATCH/PUT /cources/1.json
  def update
    respond_to do |format|
      if @cource.update(cource_params)
        format.html { redirect_to [:admin, @cource], notice: t(:updated) }
        format.json { render :show, status: :ok, location: @cource }
      else
        format.html { render :edit }
        format.json { render json: @cource.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cources/1
  # DELETE /cources/1.json

  def destroy
    @cource.destroy
    respond_to do |format|
      format.html { redirect_to admin_cources_path, notice: t(:destroyed) }
      format.json { head :no_content }
    end
  end

  def destroy_multiple
    # abort
    if (params[:ids] != nil)
      Cource.where(id: params[:ids]).destroy_all
      respond_to do |format|
        format.html { redirect_to admin_cources_path, notice: t(:destroyed) }
        format.json { head :no_content }
      end
    else
      redirect_to admin_cources_path, :alert => "Vui lòng chọn ít nhất một phần tử."
    end
  end

  def duplicate
    @cource = Cource.new(@cource.attributes)
    render :new
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_cource
    @cource = Cource.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def cource_params
    params.require(:cource).permit(:category_id, :user_id, :name, :province_id, :start_date, :schedule, :cource_date, :duration, :end_date, :address, :cost, :cost_description, :promotion, :promotion_description, :image, :content, :representative, :email, :hotline, :organization_name, :organization_address, :organization_phone, :organization_email, :organization_website, :organization_facebook, :status, :featured, :rate)
  end

  def ajax_cource_params
    params.require(:cource).permit(:id, :name, :cource_date, :address, :cost_description, :promotion, :organization_name, :rate)
  end
end
