class Admin::DashboardsController < Admin::AdminController
  before_action :set_dashboard, only: [:show, :edit, :update, :destroy]

  # GET /dashboards
  # GET /dashboards.json
  def index
    @dashboards = Dashboard.search(params[:search]).paginate(page: params[:page])
    @cources = Cource.all
    @courcesL = Cource.order(created_at: :desc).take(5)
    @courcesV = Cource.where(featured: 2).take(20)
    @courcesF = Cource.where(featured: 1).take(20)
    @categories = Category.all.order(:order)

    @export = Dashboard.all

    respond_to do |format|
      format.html
      format.xlsx {
        response.headers['Content-Disposition'] = 'attachment; filename="dashboards.xlsx"'
      }
    end
  end

  # POST /dashboards/import - THANHLV
  def import
    spreadsheet = open_spreadsheet(params[:import][:file])
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      dashboard = Dashboard.new
      dashboard.col1 = spreadsheet.row(i)[0]
      dashboard.col2 = spreadsheet.row(i)[1]
      dashboard.col3 = spreadsheet.row(i)[2]
      dashboard.save!
    end

    redirect_to admin_dashboards_path, notice: t(:import_success)
  end

  # GET /dashboards/1
  # GET /dashboards/1.json
  def show
    add_breadcrumb t(:show), :admin_dashboard_path
  end

  # GET /dashboards/new
  def new
    add_breadcrumb t(:new), :new_admin_dashboard_path
    @dashboard = Dashboard.new
  end

  # GET /dashboards/1/edit
  def edit
    add_breadcrumb t(:edit), :edit_admin_dashboard_path
  end

  # POST /dashboards
  # POST /dashboards.json
  def create
    respond_to do |format|
      if @dashboard.update(dashboard_params)
        format.html { redirect_to [:admin, @dashboard], notice: t(:updated) }
        format.json { render :show, status: :ok, location: @dashboard }
      else
        format.html { render :edit }
        format.json { render json: @dashboard.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dashboards/1
  # PATCH/PUT /dashboards/1.json
  def update
    respond_to do |format|
      if @dashboard.update(dashboard_params)
        format.html { redirect_to [:admin, @dashboard], notice: t(:updated) }
        format.json { render :show, status: :ok, location: @dashboard }
      else
        format.html { render :edit }
        format.json { render json: @dashboard.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dashboards/1
  # DELETE /dashboards/1.json
  def destroy
    @dashboard.destroy
    respond_to do |format|
      format.html { redirect_to admin_dashboards_url, notice: t(:destroyed) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dashboard
      @dashboard = Dashboard.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dashboard_params
      params.require(:dashboard).permit(:col1, :col2, :col3, :image)
    end
end
