class Admin::CategoriesController < Admin::AdminController
  before_action :set_category, only: [:show, :edit, :update, :destroy, :duplicate]

  add_breadcrumb I18n.t(:category_index_title), :admin_categories_path

  # GET /categories
  # GET /categories.json
  def index
    # Lấy tất cả danh mục
    @categories = Category.rank(:order).all

    @exports = @categories
    respond_to do |format|
      format.html
      format.xlsx {
        response.headers['Content-Disposition'] = 'attachment; filename="categories.xlsx"'
      }
    end
  end

  def reorder
    @category = Category.find(ajax_category_params[:id])
    @category.order_position = ajax_category_params[:order_position]
    @category.save!

    render nothing: true # this is a POST action, updates sent via AJAX, no view rendered
  end


  def import
    if params[:import].blank?
      redirect_to categories_path, alert: t(:import_error)
    else
      spreadsheet = open_spreadsheet(params[:import][:file])
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        category = Category.new
        category.name = spreadsheet.row(i)[0]
        category.description = spreadsheet.row(i)[1]
        category.order = spreadsheet.row(i)[2]
        category.save!
      end
      redirect_to admin_categories_path, notice: t(:import_success)
    end
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
    add_breadcrumb t(:show), :admin_category_path
  end

  # GET /categories/new
  def new
    add_breadcrumb t(:new), :new_admin_category_path
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
    add_breadcrumb t(:edit), :edit_admin_category_path
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to [:admin, @category], notice: t(:created) }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to [:admin, @category], notice: t(:updated) }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    if @category.cources.length != 0
      respond_to do |format|
        format.html { redirect_to admin_categories_url, alert: t(:undestroy_category) }
        format.json { head :no_content }
      end
    else
      @category.destroy
      respond_to do |format|
        format.html { redirect_to admin_categories_url, notice: t(:destroyed) }
        format.json { head :no_content }
      end
    end
  end

  def destroy_multiple
    i =0
    categories = Category.where(id: params[:category_ids])
    if params[:category_ids] == nil
      respond_to do |format|
        format.html { redirect_to admin_categories_url, alert: t(:delete_mutiple_alert) }
        format.json { head :no_content }
      end
      return
    end
    categories.each do |category|
      break if category.cources.length != 0
      category.destroy
      i+=1
    end
    if i==0
      respond_to do |format|
        format.html { redirect_to admin_categories_url, alert: t(:undestroy_category) }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to admin_categories_url, notice: t(:destroyed) }
        format.json { head :no_content }
      end
    end
  end

  def duplicate
    @category = Category.new(@category.attributes)
    render :new
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_category
    if params[:ids].kind_of?(Array)
      @category = Category.where("id" => params[:ids])
    else
      @category = Category.find(params[:id])
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def category_params
    params.require(:category).permit(:name, :description)
  end

  def ajax_category_params
    params.require(:category).permit(:id, :order_position)
  end
end
