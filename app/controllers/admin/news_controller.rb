class Admin::NewsController < Admin::AdminController
  before_action :set_news, only: [:show, :edit, :update, :destroy, :duplicate]

  add_breadcrumb I18n.t(:news_title), :admin_news_index_path

  # GET /news
  # GET /news.json
  def index
    @news = News.search(params[:search]).paginate(page: params[:page])
    @export = News.all
    respond_to do |format|
      format.html
      format.xlsx {
        response.headers['Content-Disposition'] = 'attachment; filename="news.xlsx"'
      }
    end
  end

  def import
    if params[:import].blank?
      redirect_to admin_news_index_path, alert: t(:import_error)
    else
    spreadsheet = open_spreadsheet(params[:import][:file])
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      new = News.new

      # Tìm danh mục theo tên
      category = CategoryNews.where(name: spreadsheet.row(i)[0]).take
      if !category.nil?

        new.category_news = category
        new.title = spreadsheet.row(i)[1]
        new.description = spreadsheet.row(i)[2]
        new.content = spreadsheet.row(i)[3]
        new.save!
      else
        redirect_to admin_news_index_path, notice: t(:missing_value)
        return
      end
    end
    redirect_to admin_news_index_path, notice: t(:import_success)
    end
  end

  # GET /news/1
  # GET /news/1.json
  def show
    add_breadcrumb t(:show), :admin_news_index_path
  end

  # GET /news/new
  def new
    add_breadcrumb t(:new), :new_admin_news_path
    @news = News.new
  end

  # GET /news/1/edit
  def edit
    add_breadcrumb t(:edit), :edit_admin_news_path
  end

  # POST /news
  # POST /news.json
  def create
    @news = News.new(news_params)

    respond_to do |format|
      if @news.save
        format.html { redirect_to [:admin, @news], notice: t(:created) }
        format.json { render :show, status: :created, location: @news }
      else
        format.html { render :new }
        format.json { render json: @news.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /news/1
  # PATCH/PUT /news/1.json
  def update
    respond_to do |format|
      if @news.update(news_params)
        format.html { redirect_to [:admin, @news], notice: t(:updated) }
        format.json { render :show, status: :ok, location: @news }
      else
        format.html { render :edit }
        format.json { render json: @news.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /news/1
  # DELETE /news/1.json
  def destroy
    @news.destroy
    respond_to do |format|
      format.html { redirect_to admin_news_index_url, notice: t(:destroyed) }
      format.json { head :no_content }
    end
  end

  def destroy_multiple
    if (params[:ids] != nil)
      News.where(id: params[:ids]).destroy_all
      respond_to do |format|
        format.html { redirect_to admin_news_index_url, notice: t(:destroyed) }
        format.json { head :no_content }
      end
    else
      redirect_to admin_news_index_path, :alert => t(:delete_mutiple_alert)
    end
  end

  def duplicate
    @news = News.new(@news.attributes)
    render :new
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_news
    if (params[:ids] == nil)
      if (params[:id] == 'destroy_multiple')
        redirect_to admin_news_index_path, :alert => t(:delete_mutiple_alert)
      else
        @news = News.find(params[:id])
      end
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def news_params
    params.require(:news).permit(:category_news_id, :title, :image, :description, :content)
  end
end
