class NewsController < FrontendController
  before_action :set_news, only: [:show]
  before_action :set_category
  add_breadcrumb I18n.t(:news), :news_index_path
  def index
    @news = News.search_by_category(params[:id]).order(updated_at: :desc).paginate(page: params[:page])
    if !(params[:id] == nil)
      @cate = CategoryNews.find_by(id: params[:id])
      cate_name = @cate.name
      add_breadcrumb cate_name
    end
  end

  def show
    add_breadcrumb t(:show), :news_path
    @related_news = News.where(category_news_id: @news.category_news_id ).where.not(id: @news.id).take(4)
    if @news.nil?
      redirect_to action: :index
    end
  end

  private
  def set_news
    @news = News.find(params[:id])
    @courceVips = @courceVips.take(2)
  end

  def set_category
    @category_news = CategoryNews.all
  end

  # def set_cource_vips
  #   @courceVips.take(2)
  # end
  # def search_by_category
  #   @news = News.find(56).take
  #   render :index
  # end

  # def search_by_category()
end
