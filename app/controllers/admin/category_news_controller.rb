class Admin::CategoryNewsController < Admin::AdminController
  before_action :set_category_news, only: [:show, :edit, :update, :destroy, :duplicate]

  add_breadcrumb I18n.t(:category_news_index_title), :admin_category_news_index_path

  # GET /category_news
  # GET /category_news.json
  def index
    @category_news = CategoryNews.search(params[:search]).paginate(page: params[:page])

    @export = CategoryNews.all

    respond_to do |format|
      format.html
      format.xlsx {
        response.headers['Content-Disposition'] = 'attachment; filename="categorynews.xlsx"'
      }
    end

  end

  def import
    if params[:import].blank?
      redirect_to admin_category_news_index_path, alert: t(:import_error)
    else
      spreadsheet = open_spreadsheet(params[:import][:file])
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        category_news = CategoryNews.new
        category_news.name = spreadsheet.row(i)[0]
        category_news.description = spreadsheet.row(i)[1]
        category_news.save!
    end

    redirect_to admin_category_news_index_path, notice: t(:import_success)
    end
  end

  # GET /category_news/1
  # GET /category_news/1.json

  def show
    add_breadcrumb t(:show), :admin_category_news_path
  end

  # GET /category_news/new
  def new
    add_breadcrumb t(:new), :new_admin_category_news_path
    @category_news = CategoryNews.new
  end

  # GET /category_news/1/edit
  def edit
    add_breadcrumb t(:edit), :edit_admin_category_news_path
  end

  # POST /category_news
  # POST /category_news.json
  def create
    @category_news = CategoryNews.new(category_news_params)

    respond_to do |format|
      if @category_news.save
        format.html { redirect_to admin_category_news_index_url, notice: t(:created) }
        format.json { render :show, status: :created, location: @category_news }
      else
        format.html { render :new }
        format.json { render json: @category_news.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /category_news/1
  # PATCH/PUT /category_news/1.json
  def update
    respond_to do |format|
      if @category_news.update(category_news_params)
        format.html { redirect_to admin_category_news_index_url, notice: t(:updated) }
        format.json { render :show, status: :ok, location: @category_news }
      else
        format.html { render :edit }
        format.json { render json: @category_news.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /category_news/1
  # DELETE /category_news/1.json

  def destroy
    @category_news.destroy
    respond_to do |format|
      format.html { redirect_to admin_category_news_index_url, notice: t(:destroyed) }
      format.json { head :no_content }
    end
  end

  def destroy_multiple
    # abort
    if (params[:ids] != nil)
      CategoryNews.where(id: params[:ids]).destroy_all
      respond_to do |format|
        format.html { redirect_to admin_category_news_index_url, notice: t(:destroyed) }
        format.json { head :no_content }
      end
    else
      redirect_to admin_category_news_index_path, :alert => "Vui lòng chọn ít nhất một phần tử."
    end
  end


  def duplicate
    @category_news = CategoryNews.new(@category_news.attributes)
    render :new
  end

  private
  # Use callbacks to share common setup or constraints between actions.

  def set_category_news
    @category_news = CategoryNews.find(params[:id])
  end
  # Never trust parameters from the scary internet, only allow the white list through.
  def category_news_params
    params.require(:category_news).permit(:name, :description)
  end
end
