class UserPastebinsController < ApplicationController
  before_action :set_user_pastebin, only: [:show, :edit, :update, :destroy]

  def action_allowed?
    case params[:action]
    when 'index', 'create'
      ['Instructor',
       'Teaching Assistant',
       'Student',
       'Administrator'].include? current_role_name
    end
  end

  # GET /user_pastebins
  def index
    begin

      json = UserPastebin.get_current_user_pastebin_json current_user
      render json: json

    rescue => e
      flash[:error] = e.message
    end
  end

  # GET /user_pastebins/1
  def show; end

  # GET /user_pastebins/new
  def new
    @user_pastebin = UserPastebin.new
  end

  # GET /user_pastebins/1/edit
  def edit; end

  # POST /user_pastebins
  def create
    @user_pastebin = UserPastebin.new(user_pastebin_params)
    @user_pastebin.user_id = current_user.id
    if @user_pastebin.save
      data = UserPastebin.get_current_user_pastebin_json current_user
      render json: data, status: 200
    else
      data = {message: "Short Form or Long Form is not valid"}
      render json: data, status: 422
    end
  end

  # PATCH/PUT /user_pastebins/1
  def update
    if @user_pastebin.update(user_pastebin_params)
      redirect_to @user_pastebin, notice: 'User pastebin was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /user_pastebins/1
  def destroy
    @user_pastebin.destroy
    redirect_to user_pastebins_url, notice: 'User pastebin was successfully destroyed.'
  end

  private

    # Use callbacks to share common setup or constraints between actions.
  def set_user_pastebin
    @user_pastebin = UserPastebin.find(params[:id])
  end

    # Only allow a trusted parameter "white list" through.
  def user_pastebin_params
    params.permit(:user_id, :short_form, :long_form)
  end
end
