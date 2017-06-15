class UserAditsController < ApplicationController
  before_action :set_user_adit, only: [:show, :edit, :update, :destroy]

  # GET /user_adits
  # GET /user_adits.json
  def index
    @user_adits = UserAdit.all
    @users = User.all
  end

  # GET /user_adits/1
  # GET /user_adits/1.json
  def show
  end

  # GET /user_adits/new
  def new
    @user_adit = UserAdit.new
  end

  # GET /user_adits/1/edit
  def edit
  end

  # POST /user_adits
  # POST /user_adits.json
  def create
    @user_adit = UserAdit.new(user_adit_params)

    respond_to do |format|
      if @user_adit.save
        format.html { redirect_to @user_adit, notice: 'User adit was successfully created.' }
        format.json { render :show, status: :created, location: @user_adit }
      else
        format.html { render :new }
        format.json { render json: @user_adit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_adits/1
  # PATCH/PUT /user_adits/1.json
  def update
    respond_to do |format|
      if @user_adit.update(user_adit_params)
        format.html { redirect_to @user_adit, notice: 'User adit was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_adit }
      else
        format.html { render :edit }
        format.json { render json: @user_adit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_adits/1
  # DELETE /user_adits/1.json
  def destroy
    @user_adit.destroy
    respond_to do |format|
      format.html { redirect_to user_adits_url, notice: 'User adit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_adit
      @user_adit = UserAdit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_adit_params
      params.require(:user_adit).permit(:user_id, :cource_id, :action_type)
    end
end
