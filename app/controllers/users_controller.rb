class UsersController < ApplicationController
  before_action :authenticate_user!
  #load_and_authorize_resource param_method: :user_params

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
  		redirect_to users_list_path
  	else
  		render :new
  	end
  end

  def list
  	@users = User.all.order('created_at DESC')
  end

  def user_params
  	params.require(:user).permit(:first_name, :last_name, :email, :active, :business_name, :address, :phone, :fax, :website, :email, :contact_person_email, :contact_person_number)
  end
end
