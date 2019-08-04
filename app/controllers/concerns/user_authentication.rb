module Concerns::UserAuthentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user
    before_action :set_user
  end

  def authenticate_user
    token = request.headers['Session-Token']
    @user_identity = UserIdentity.find_by_access_token(token)
    render json: { success: false, error: 'Unauthorized' }, status: :unauthorized if @user_identity.blank?
  end

  def set_user
    @current_user = @user_identity.user
  end

  def set_device_type
    @device_type = request.headers['HTTP_DEVICE_TYPE']
  end
end
