class Admin::ConfigsController < Admin::AdminController
  before_action :set_config, only: [:show, :edit, :update, :destroy, :duplicate]

  add_breadcrumb I18n.t(:config_index_title), :admin_configs_path

  # GET /configs
  # GET /configs.json
  def index
    @configs = Config.search(params[:search]).paginate(page: params[:page])
    @export = Config.all

    respond_to do |format|
      format.html
      format.xlsx {
        response.headers['Content-Disposition'] = 'attachment; filename="Configs.xlsx"'
      }
    end
  end

  #Import
  def import
    if params[:import].blank?
      redirect_to admin_configs_path, alert: t(:import_error)
    else
      spreadsheet = open_spreadsheet(params[:import][:file])
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        config = Config.new
        config.code = spreadsheet.row(i)[0]
        config.value = spreadsheet.row(i)[1]
        config.save!
      end

      redirect_to admin_configs_path, notice: t(:config_import_success)
    end
  end

  # GET /configs/1
  # GET /configs/1.json
  def show
    add_breadcrumb t(:show), :admin_config_path
  end

  # GET /configs/new
  def new
    add_breadcrumb t(:new), :new_admin_config_path
    @config = Config.new
  end

  # GET /configs/1/edit
  def edit
    add_breadcrumb t(:edit), :edit_admin_config_path
  end

  # POST /configs
  # POST /configs.json
  def create
    @config = Config.new(config_params)

    respond_to do |format|
      if @config.save
        format.html { redirect_to [:admin, @config], notice: t(:created) }
        format.json { render :show, status: :created, location: @config }
      else
        format.html { render :new }
        format.json { render json: @config.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /configs/1
  # PATCH/PUT /configs/1.json
  def update
    respond_to do |format|
      if @config.update(config_params)
        format.html { redirect_to [:admin, @config], notice: t(:updated) }
        format.json { render :show, status: :ok, location: @config }
      else
        format.html { render :edit }
        format.json { render json: @config.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /configs/1
  # DELETE /configs/1.json
  def destroy
    if (params[:ids] != nil)
      Config.where(id: params[:ids]).destroy_all
    else
      @config.destroy
    end
    respond_to do |format|
      format.html { redirect_to admin_configs_url, notice: t(:destroyed) }
      format.json { head :no_content }
    end
  end
  # DELETE ALL
  def destroy_multiple
    # abort
    if (params[:ids] != nil)
      Config.where(id: params[:ids]).destroy_all
      respond_to do |format|
        format.html { redirect_to admin_configs_url, notice: t(:destroyed) }
        format.json { head :no_content }
      end
    else
      redirect_to admin_configs_path, :alert => "Vui lòng chọn ít nhất một phần tử."
    end
  end

  def duplicate
    @config = Config.new(@config.attributes)
    render :new
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_config
      if (params[:ids] == nil)
        if (params[:id] == 'destroy_multiple')
          redirect_to admin_configs_path, :alert => "Vui lòng chọn ít nhất một phần tử."
        else
          @config = Config.find(params[:id])
        end
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def config_params
      params.require(:config).permit(:code, :value)
    end
end
