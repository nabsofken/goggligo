class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:edit, :show, :update]

  #load_and_authorize_resource param_method: :user_params

  def new
  	@user = User.new
  end

  def edit
  end

  def show
    @notice = session[:notice]
    session[:notice] = nil
    @error = session[:error]
    session[:error] = nil
  end

  def create_user
  	@user = User.new(user_params)
  	if @user.save
      session[:notice] = 'Successfully created new user'
  		
  	  respond_to do |format|
        format.html {redirect_to users_path}
        format.js {render js: "window.location.href='"+users_path+"'"}
      end 
    else
      @error = @user.errors.full_messages.to_sentence
  		respond_to do |format|
        format.html  {render :new}
        format.js
      end
    end
  end

  def update
    @user.password = user_params[:password_visible]
    if @user.update(user_params)
      respond_to do |format|
        format.html {redirect_to users_path, notice: 'Successfully updated user'}
        format.js {render js: "window.location.href='"+users_path+"'"}
      end
    else
      respond_to do |format|
        format.html  {render :edit}
        format.js
      end
    end
  end

  def set_user
    @user = User.find_by(id: params[:id])
    if @user.blank?
      session[:error] = 'No user found'
      redirect_to users_path
    end
  end

  def index
    @notice = session[:notice]
    session[:notice] = nil
    @error = session[:error]
    session[:error] = nil
  	@users = User.doctors.order('created_at DESC')
    @users = @users.where("business_name like :s", :s => "%#{params[:search]}%") if params[:search].present?
  end
  
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :active, :business_name, :address, :phone, :fax, :website, :email, :contact_person_email, :contact_person_number, :password, :password_visible)
  end
end
