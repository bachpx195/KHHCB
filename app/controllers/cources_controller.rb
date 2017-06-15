class CourcesController < FrontendController
  before_action :set_cource, only: [:show, :publish]
  before_filter :authenticate_user!, only: [:new, :create, :viewed, :registed]

  add_breadcrumb I18n.t(:cource_index_title), :cources_path

  # Xem thêm
  def ajax
    @cources = Cource.all.paginate(page: params[:page])
    @type = params[:type]
    render :layout => false
  end

  # Danh sách khóa học
  def index

    if params.include?(:search)
      # TODO: Tìm kiếm theo điều kiện tìm kiếm và trả về kết quả.
      add_breadcrumb I18n.t(:search)
      @courceCategory = Cource.searchCategory(params[:search])
      @courceProvince = Cource.searchProvince(params[:search])
      @courceCost = Cource.searchCost(params[:search])
      @courceTime = Cource.searchTime(params[:search])
      @cources = (@courceCategory).merge(@courceProvince).merge(@courceCost).merge(@courceTime)
      @cources = @cources.paginate(page: params[:page])
    else
      @cources = Cource.all.paginate(page: params[:page])
    end

  end

  # Đăng tải khóa học
  def new
    add_breadcrumb I18n.t(:user_cource_register), :new_cource_path
    @cource = Cource.new
    @posted_cources = Cource.where(user_id: current_user.id)
    @user_adit = UserAdit.where(user_id: current_user.id).paginate(page: params[:page])

  end

  def create
    @user_adit = UserAdit.where(user_id: current_user.id).paginate(page: params[:page])
    @posted_cources = Cource.where(user_id: current_user.id)
    @cource = Cource.new(cource_params)
    # Mặc định thông tin người tạo là người đăng nhập - :user_id
    @cource.user = current_user
    @cource.status = 2
    # TODO: Trạng thái lưu nháp hoặc trạng thái gửi xét duyệt. - :status
    if params[:commit] == t(:cource_pendding_approved)
      @cource.status = 1
    elsif params[:commit] == t(:cource_draft)
      @cource.status = 0
    end

    # TODO: Trạng thái khóa học mặc định là thường. - :featured
    @cource.featured = "Thường"
    # TODO: Mặc định không xử lý đánh giá. - :rate
    @cource.rate = 0
    @user_adit = UserAdit.where(user_id: current_user.id).paginate(page: params[:page])

    respond_to do |format|
      if @cource.save
        format.html { redirect_to cource_path(@cource), notice: t(:created) }
        format.json { render :show, status: :created, location: @cource }
      else
        format.html { render :new }
        format.json { render json: @cource.errors, status: :unprocessable_entity }
      end
    end
  end


  # Khóa học đã xem
  def viewed
    add_breadcrumb I18n.t(:user_cources_viewed), :viewed_cources_path
    # TODO: Trả về danh sách khóa học đã xem.
    @user_adit = UserAdit.where(user_id: current_user.id).paginate(page: params[:page])
    @posted_cources = Cource.where(user_id: current_user.id)

  end

  # Khóa học đã đăng
  def registed
    add_breadcrumb I18n.t(:user_cources_registed), :registed_cources_path
    # Lấy khóa học của người dùng đó.
    @cources = Cource.where(user: current_user).paginate(page: params[:page])
    @posted_cources = Cource.where(user_id: current_user.id)
    @user_adit = UserAdit.where(user_id: current_user.id).paginate(page: params[:page])

  end

  # Chi tiết khóa học
  def show

    if !(@cource.nil?)
      @courcesCategoryRelated = Cource.where(category: @cource.category).take(4) #Liên quan trong cùng danh mục
      # logger.debug "#{@ource.category_id}"
      @courcesRelated = Cource.take(4)
      @courcesFeatured = Cource.where(featured: 2).take(4)
      # @courcesFeatured = Cource.where(featured: 1).take(4)

      # TOANDK EDIT 7-11-2016
      @update_viewed_count = Cource.find_by(id: @cource.id)
      if (@update_viewed_count.viewed_count.nil?)
        @update_viewed_count.update(viewed_count: 1)
      else
        @update_viewed_count.update(viewed_count: @update_viewed_count.viewed_count + 1)
      end

      if !(current_user.blank?)
        @user_adit = UserAdit.where(user_id: current_user.id, cource_id: @cource.id, action_type: "1")
        if (@user_adit.blank?)
          @user_adit = UserAdit.new(user_id: current_user.id, cource_id: @cource.id, action_type: "1")
          @user_adit.save
        end
      end
      # TOANDK EDIT 7-11-2016
    end
  end

  private
  def set_cource
    @cource = Cource.find(params[:id])
  end

  def cource_params
    params.require(:cource).permit(:category_id, :name, :province_id, :start_date, :schedule, :cource_date, :duration, :end_date, :address, :cost, :cost_description, :promotion, :promotion_description, :image, :content, :representative, :email, :hotline, :organization_name, :organization_address, :organization_phone, :organization_email, :organization_website, :organization_facebook)
  end
end
