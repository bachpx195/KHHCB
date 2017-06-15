class Admin::SlidesController < Admin::AdminController
  before_action :set_slide, only: [:show, :edit, :update, :destroy]

  add_breadcrumb I18n.t(:slide_index_title), :admin_slides_path

  # GET /slides
  # GET /slides.json
  def index
    @slides = Slide.search(params[:search]).paginate(page: params[:page])

    @export = Slide.all

    respond_to do |format|
      format.html
      format.xlsx {
        response.headers['Content-Disposition'] = 'attachment; filename="slide.xlsx"'
      }
    end
  end

  # GET /slides/1
  # GET /slides/1.json
  def show
    add_breadcrumb t(:show), :admin_slide_path
  end

  # GET /slides/new
  def new
    add_breadcrumb t(:new), :new_admin_slide_path
    @slide = Slide.new
  end

  # GET /slides/1/edit
  def edit
    add_breadcrumb t(:edit), :edit_admin_slide_path
  end

  # POST /slides/import - ThinhLV
  def import
    if params[:import].blank?
      redirect_to admin_slides_path, alert: t(:import_error)
    else
      spreadsheet = open_spreadsheet(params[:import][:file])
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        slide = Slide.new
        slide.name = spreadsheet.row(i)[0]
        slide.description = spreadsheet.row(i)[2]
        slide.url = spreadsheet.row(i)[3]
        slide.status = spreadsheet.row(i)[4]
        slide.save!
      end

        redirect_to admin_slides_path, notice: t(:import_success)
    end
  end

  # POST /slides
  # POST /slides.json
  def create
    @slide = Slide.new(slide_params)

    respond_to do |format|
      if @slide.save
        format.html { redirect_to [:admin, @slide], notice: t(:created) }
        format.json { render :show, status: :created, location: @slide }
      else
        format.html { render :new }
        format.json { render json: @slide.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /slides/1
  # PATCH/PUT /slides/1.json
  def update
    respond_to do |format|
      if @slide.update(slide_params)
        format.html { redirect_to [:admin, @slide], notice: t(:updated) }
        format.json { render :show, status: :ok, location: @slide }
      else
        format.html { render :edit }
        format.json { render json: @slide.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /slides/1
  # DELETE /slides/1.json
  def destroy
    if (params[:ids] != nil)
      Slide.where(id: params[:ids]).destroy_all
    else
      @slide.destroy
    end
    respond_to do |format|
      format.html { redirect_to admin_slides_url, notice: t(:destroyed) }
      format.json { head :no_content }
    end
  end

  def duplicate
  @slide = Slide.new(@slide.attributes)
  render :new
  end

  def destroy_multiple
    # abort
    if (params[:ids] != nil)
      Slide.where(id: params[:ids]).destroy_all
      respond_to do |format|
        format.html { redirect_to admin_slides_path, notice: t(:destroyed) }
        format.json { head :no_content }
      end
    else
      redirect_to admin_slides_path, :alert => "Vui lòng chọn ít nhất một phần tử."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_slide
      if (params[:ids] == nil)
        if (params[:id] == 'destroy_multiple')
          redirect_to admin_slides_path, :alert => "Vui lòng chọn ít nhất một phần tử."
        else
          @slide = Slide.find(params[:id])
        end
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def slide_params
      params.require(:slide).permit(:name, :image, :description, :url, :status)
    end
end
