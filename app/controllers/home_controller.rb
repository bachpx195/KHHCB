class HomeController < FrontendController

  def index
    #BANNER
    @banner1 = Banner.where(status: 1, position: 1).take
    @banner2 = Banner.where(status: 1, position: 2).take

    # KHÓA HỌC NỔI BẬT
    @featured = Cource.where(featured: 1).take(4)

    # DANH SÁCH KHÓA HỌC
    @cources = Cource.searchID(params[:searchID]).paginate(page: params[:page])
  end
end
