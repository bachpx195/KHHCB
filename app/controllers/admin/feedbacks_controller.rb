class Admin::FeedbacksController < Admin::AdminController
  before_action :set_feedback, only: [:show, :edit, :update, :destroy, :duplicate]

  add_breadcrumb I18n.t(:feedbacks_index_title), :admin_feedbacks_path

  # GET /provinces
  # GET /provinces.json
  def index
    @feedbacks = Feedback.search(params[:search]).paginate(page: params[:page])
    @export = Feedback.all

    respond_to do |format|
      format.html
      format.xlsx {
        response.headers['Content-Disposition'] = 'attachment; filename="feddbacks.xlsx"'
      }
    end
  end

  def import
    if params[:file].blank?
      redirect_to admin_feedbacks_path, alert: t(:feedback_import_error)
    else
    spreadsheet = open_spreadsheet(params[:import][:file])
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      feedback = Feedback.new
      feedback.description = spreadsheet.row(i)[0]
      feedback.save!
    end

    redirect_to admin_feedbacks_path, notice: t(:import_success)
    end
  end
  # GET /feedbacks/1
  # GET /feedbacks/1.json
  def show
    add_breadcrumb t(:show), :admin_feedback_path
  end

  # GET /feedbacks/new
  def new
    add_breadcrumb t(:new), :new_admin_feedback_path
    @feedback = Feedback.new
  end

  # GET /feedbacks/1/edit
  def edit
    add_breadcrumb t(:edit), :edit_admin_feedback_path
  end

  # POST /feedbacks
  # POST /feedbacks.json
  def create
    @feedback = Feedback.new(feedback_params)

    respond_to do |format|
      if @feedback.save
        format.html { redirect_to [:admin, @feedback], notice: t(:created) }
        format.json { render :show, status: :created, location: @feedback }
      else
        format.html { render :new }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /feedbacks/1
  # PATCH/PUT /feedbacks/1.json
  def update
    respond_to do |format|
      if @feedback.update(feedback_params)
        format.html { redirect_to [:admin, @feedback], notice: t(:updated) }
        format.json { render :show, status: :ok, location: @feedback }
      else
        format.html { render :edit }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feedbacks/1
  # DELETE /feedbacks/1.json
  def destroy
    # abort
    if (params[:ids] != nil)
      Feedback.where(id: params[:ids]).destroy_all
    else
      @feedback.destroy
    end
    respond_to do |format|
      format.html { redirect_to admin_feedbacks_url, notice: t(:destroyed) }
      format.json { head :no_content }
    end
  end

  def destroy_multiple
    # abort
    if (params[:ids] != nil)
      Feedback.where(id: params[:ids]).destroy_all
      respond_to do |format|
        format.html { redirect_to admin_feedbacks_url, notice: t(:destroyed) }
        format.json { head :no_content }
      end
    else
      redirect_to admin_feedbacks_path, :alert => "Vui lòng chọn ít nhất một phần tử."
    end
  end

  def duplicate
    @feedback = Feedback.new(@feedback.attributes)
    render :new
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feedback
      if (params[:ids] == nil)
        if (params[:id] == 'destroy_multiple')
          redirect_to feedbacks_path, :alert => "Vui lòng chọn ít nhất một phần tử."
        else
          @feedback = Feedback.find(params[:id])
        end
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def feedback_params
      params.require(:feedback).permit(:description)
    end
end
