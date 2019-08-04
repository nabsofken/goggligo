# require 'api/api_response_helper.rb'

class Api::V1::Devise::SessionsController < Devise::SessionsController
  include ApiResponseHelper
  include Concerns::UserAuthentication

  skip_before_action :verify_signed_out_user
  before_action :authenticate_user, only: [:destroy]
  before_action :set_user, only: [:destroy]
  before_action :validate_login_params, only: [:create]
  before_action :set_device_type, only: [:create]

  resource_description do
    short "Handle user's multiple sessions from multiple devices"
  end

  def_param_group :signin_params do
    param :user, Hash, required: true do
      param :email, String, required: true
      param :password, String, required: true
      param :device_id, String, required: true
    end
  end

  api :POST, '/users/sign_in', "User Sign-In"
  param_group :signin_params
  formats ['json']
  description 'User can sign in from multiple devices'
  def create
    resource = User.find_for_database_authentication(login_params)
    return invalid_login_attempt unless resource

    if resource.valid_password?(params[:user][:password])
      access_token = resource.generate_access_token(params[:user][:device_id])
      if access_token.present?
        sign_in(:user, resource)
        created(data: LoginResponseSerializer.new(resource, scope: {access_token: access_token}))
      else
        internal_server_error
      end
    else
      invalid_login_attempt
    end
  end

  api :DELETE, '/users/sign_out', "User Sign-Out"
  formats ['json']
  description "User's current scope from a single device is signout"
  def destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(@current_user.email)
    @user_identity.destroy
    render json: {success: true}, status: :ok
  end

  private

  def login_params
    params.require(:user).permit(:email)
  end

  def invalid_login_attempt error=nil
    error = 'Invalid login attempt' if error.blank?
    render json: {success: false, error: error}, status: :forbidden
  end

  def validate_login_params
    begin
      invalid_login_attempt if login_params.blank? || params[:user][:device_id].blank?
    rescue ActionController::ParameterMissing
      invalid_login_attempt
    end
  end

end
