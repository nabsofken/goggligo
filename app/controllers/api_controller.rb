class ApiController < ActionController::Base
  include ApiResponseHelper
  #before_action :validate_app_version
  #before_action :authenticate_request
  before_action :can_can
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  rescue_from CanCan::AccessDenied do
    unauthorized
  end

  rescue_from ActionController::ParameterMissing do |exception|
    unprocessable_entity('Required params missing')
  end

  def can_can
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  private

  def validate_app_version
    @device_type = request.headers['HTTP_DEVICE_TYPE']
    return invalid_application_version("Old application version") unless VersionControl.validate_version(request.headers['HTTP_DEVICE_TYPE'], request.headers['HTTP_APP_VERSION'])
  end

  def authenticate_request
    token = APP_CONFIG[:api][:access_token]
    return unauthorized("Invalid Authorization-Token") unless token == request.headers['HTTP_AUTHORIZATION']
  end

end
