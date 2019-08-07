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
  end

  def create_user
  	@user = User.new(user_params)
  	if @user.save
  		redirect_to users_path
  	else
  		render :new
  	end
  end

  def update
    if @user.update(user_params)
      redirect_to users_path
    else
      render :edit
    end
  end

  def set_user
    @user = User.find_by(id: params[:id])
    redirect_to users_path if @user.blank?
  end

  def index
  	@users = User.all.order('created_at DESC')
  end

  def user_params
  	params.require(:user).permit(:first_name, :last_name, :email, :active, :business_name, :address, :phone, :fax, :website, :email, :contact_person_email, :contact_person_number)
  end
end
