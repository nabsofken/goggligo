class Api::V1::Devise::RegistrationsController < Devise::RegistrationsController
  include Concerns::UserAuthentication

  skip_before_action :authenticate_user, only: [:create]
  skip_before_action :set_user, only: [:create]
  before_action :validate_signup_params, only: [:create]
  before_action :set_device_type, only: [:create]

  resource_description do
    short "Handle user's registrations process"
  end

  def_param_group :sign_up_params_group do
    param :user, Hash, required: true do
      param :email, String, required: true
      param :device_id, String, required: true
      param :first_name, String, required: true
      param :last_name, String, required: true
      param :password, String, required: true

    end
  end

  api :POST, '/users', "User Sign-Up"
  param_group :sign_up_params_group
  formats ['json']
  description 'User can sign up'
  def create
    resource = User.new sign_up_params
    if resource.save
      access_token = resource.generate_access_token(params[:user][:device_id])
      if access_token.present?
        sign_in(:user, resource)
      end

      return render json: {success: true, user_id: resource.id, message: "Your account is created successfully but still needs to be verified"}, status: :created
    else
      render json: {success: false, errors: resource.errors}, status: :unprocessable_entity
    end
  end

  private

  def sign_up_params
    allow = [:email, :first_name, :last_name, :password]

    params.require(:user).permit(allow)
  end

  def invalid_signup_attempt error=nil
    error = 'Invalid signup attempt' if error.blank?
    render json: {success: false, error: error}, status: :unauthorized
  end

  def validate_signup_params
    begin
      invalid_signup_attempt if sign_up_params.blank? || params[:user][:device_id].blank?
    rescue ActionController::ParameterMissing
      invalid_signup_attempt
    end
  end

end
