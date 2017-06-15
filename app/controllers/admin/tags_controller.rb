class Admin::TagsController < Admin::AdminController
  before_action :set_tag, only: [:show, :edit, :update, :destroy, :duplicate]

  add_breadcrumb I18n.t(:tag_index_title), :admin_tags_path

  # GET /tags
  # GET /tags.json
  def index
    @tags = Tag.search(params[:search]).paginate(page: params[:page])
    @export = Tag.all

    respond_to do |format|
      format.html
      format.xlsx {
        response.headers['Content-Disposition'] = 'attachment; filename="Tags.xlsx"'
      }
    end
  end

  #Import
  def import
    if params[:import].blank?
      redirect_to admin_tags_path, alert: t(:import_error)
        else
          spreadsheet = open_spreadsheet(params[:import][:file])
          header = spreadsheet.row(1)
          (2..spreadsheet.last_row).each do |i|
          tag = Tag.new
          tag.name = spreadsheet.row(i)[0]
          tag.save!
        end
          redirect_to admin_tags_path, notice: t(:tag_import_success)
      end
  end


  # GET /tags/1
  # GET /tags/1.json
  def show
    add_breadcrumb t(:show), :admin_tag_path
  end

  # GET /tags/new
  def new
    add_breadcrumb t(:new), :new_admin_tag_path
    @tag = Tag.new
  end

  # GET /tags/1/edit
  def edit
    add_breadcrumb t(:edit), :edit_admin_tag_path
  end

  # POST /tags
  # POST /tags.json
  def create
    @tag = Tag.new(tag_params)

    respond_to do |format|
      if @tag.save
        format.html { redirect_to [:admin, @tag], notice: t(:created) }
        format.json { render :show, status: :created, location: @tag }
      else
        format.html { render :new }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /provinces/1
  # PATCH/PUT /provinces/1.json
  def update
    respond_to do |format|
      if @tag.update(tag_params)
        format.html { redirect_to [:admin, @tag], notice: t(:updated) }
        format.json { render :show, status: :ok, location: @tag }
      else
        format.html { render :edit }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE/tag/1
  # DELETE/tag/1.json
  def destroy
    if (params[:ids] != nil)
      Tag.where(id: params[:ids]).destroy_all
    else
      @tag.destroy
    end
    respond_to do |format|
      format.html { redirect_to admin_tags_url, notice: t(:destroyed) }
      format.json { head :no_content }
    end
  end
  # DELETE ALL
  def destroy_multiple
    # abort
    if (params[:ids] != nil)
      Tag.where(id: params[:ids]).destroy_all
      respond_to do |format|
        format.html { redirect_to admin_tags_url, notice: t(:destroyed) }
        format.json { head :no_content }
      end
    else
      redirect_to admin_tags_path, :alert => "Vui lòng chọn ít nhất một phần tử."
    end
  end

  def duplicate
    @tag = Tag.new(@tag.attributes)
    render :new
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tag
      if (params[:ids] == nil)
        if (params[:id] == 'destroy_multiple')
          redirect_to tags_path, :alert => "Vui lòng chọn ít nhất một phần tử."
        else
          @tag = Tag.find(params[:id])
        end
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tag_params
      params.require(:tag).permit(:name)
    end
end
