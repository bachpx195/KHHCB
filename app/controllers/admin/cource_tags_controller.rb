class Admin::CourceTagsController < Admin::AdminController
  before_action :set_cource_tag, only: [:show, :edit, :update, :destroy]

  # GET /cource_tags
  # GET /cource_tags.json
  def index
    @cource_tags = CourceTag.all
  end

  # GET /cource_tags/1
  # GET /cource_tags/1.json
  def show
  end

  # GET /cource_tags/new
  def new
    @cource_tag = CourceTag.new
  end

  # GET /cource_tags/1/edit
  def edit
  end

  # POST /cource_tags
  # POST /cource_tags.json
  def create
    @cource_tag = CourceTag.new(cource_tag_params)

    respond_to do |format|
      if @cource_tag.save
        format.html { redirect_to [:admin, @cource_tag], notice: 'Cource tag was successfully created.' }
        format.json { render :show, status: :created, location: @cource_tag }
      else
        format.html { render :new }
        format.json { render json: @cource_tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cource_tags/1
  # PATCH/PUT /cource_tags/1.json
  def update
    respond_to do |format|
      if @cource_tag.update(cource_tag_params)
        format.html { redirect_to [:admin, @cource_tag], notice: 'Cource tag was successfully updated.' }
        format.json { render :show, status: :ok, location: @cource_tag }
      else
        format.html { render :edit }
        format.json { render json: @cource_tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cource_tags/1
  # DELETE /cource_tags/1.json
  def destroy
    @cource_tag.destroy
    respond_to do |format|
      format.html { redirect_to admin_cource_tags_url, notice: 'Cource tag was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cource_tag
      @cource_tag = CourceTag.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cource_tag_params
      params.require(:cource_tag).permit(:cource_id, :tag_id)
    end
end
