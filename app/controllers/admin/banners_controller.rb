class Admin::BannersController < Admin::AdminController
  before_action :set_banner, only: [:show, :edit, :update, :destroy, :duplicate]

  add_breadcrumb I18n.t(:banner_index_title), :admin_banners_path

  # GET /banners
  # GET /banners.json
  def index
    @banners = Banner.search(params[:search]).order(:updated_at).paginate(page: params[:page])
    # order(updated_at)
    @export = Banner.all

    respond_to do |format|
      format.html
      format.xlsx {
        response.headers['Content-Disposition'] = 'attachment; filename="banners.xlsx"'
      }
    end

  end


  def import

    if params[:import].blank?
      redirect_to admin_banners_path, alert: t(:import_error)
    else
      spreadsheet = open_spreadsheet(params[:import][:file])
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        banner = Banner.new
        banner.name = spreadsheet.row(i)[0]
        # banner.image = spreadsheet.row(i)[1]
        banner.url = spreadsheet.row(i)[2]
        banner.position = spreadsheet.row(i)[3]
        banner.status = spreadsheet.row(i)[4]
        banner.save!
        change(banner)
      end
      redirect_to admin_banners_path, notice: t(:import_success)
    end
  end

  # GET /banners/1
  # GET /banners/1.json
  def show
    add_breadcrumb t(:show), :admin_banner_path
  end

  # GET /banners/new
  def new
    add_breadcrumb t(:new), :new_admin_banner_path
    @banner = Banner.new

  end

  # GET /banners/1/edit
  def edit
    add_breadcrumb t(:edit), :edit_admin_banner_path
  end

  # POST /banners
  # POST /banners.json
  def create
    @banner = Banner.new(banner_params)

    change(@banner)
    respond_to do |format|
      if @banner.save
        format.html { redirect_to admin_banners_url, notice: t(:created) }
        format.json { render :show, status: :created, location: @banner }
      else
        format.html { render :new }
        format.json { render json: @banner.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /banners/1
  # PATCH/PUT /banners/1.json
  def update
       respond_to do |format|
        if @banner.update(banner_params)
           change(@banner)
           format.html { redirect_to admin_banners_url, notice: t(:updated) }
          format.json { render :show, status: :ok, location: @banner }
         else
          format.html { render :edit }
          format.json { render json: @banner.errors, status: :unprocessable_entity }
        end
    end
  end

  # DELETE /banners/1
  # DELETE /banners/1.json
  def destroy
    @banner.destroy
    respond_to do |format|
      format.html { redirect_to admin_banners_url, notice: t(:destroyed) }
      format.json { head :no_content }
    end
  end


  def destroy_multiple
    # abort
    if (params[:ids] != nil)
      Banner.where(id: params[:ids]).destroy_all
      respond_to do |format|
        format.html { redirect_to admin_banners_url, notice: t(:destroyed) }
        format.json { head :no_content }
      end
    else
      # if (param[:id] != nil)
      #   @banner.destroy
      # else
      #   redirect_to admin_banners_path, :alert => "Vui lòng chọn ít nhất một phần tử."
      # end
      redirect_to admin_banners_path, :alert => "Vui lòng chọn ít nhất một phần tử."
    end
  end

  def duplicate
    @banner = Banner.new(@banner.attributes)
    render :new
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_banner
    @banner =Banner.find(params[:id])
  end

  def change(banner)
    if banner.status == 1
      banners = Banner.where('position' => banner.position)
      banners.each do |b|
        if b.id == banner.id
          next
        end
        b.update(status: '0')
      end
    end
  end


    # Never trust parameters from the scary internet, only allow the white list through.
    def banner_params
      params.require(:banner).permit(:name, :image, :url, :position, :status)
    end
  end

