class FeedbackController < FrontendController
  add_breadcrumb "phản hồi", :feedback_new_path
  def new
    @feedback = Feedback.new
  end

  def create
    @feedback = Feedback.new(feedback_params)

    respond_to do |format|
      if @feedback.save
        format.html { redirect_to feedback_new_path, notice: t(:created) }
        format.json { render :show, status: :created, location: @feedback }
      else
        format.html { render :new }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  def feedback_params
    params.require(:feedback).permit(:description)
  end
end
