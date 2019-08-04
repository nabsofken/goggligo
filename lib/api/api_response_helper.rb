module ApiResponseHelper
  def success(data = nil)
    response = { success: true }
    response.merge!(data) if data.present?
    render json: response, status: :ok
  end

  def created(data = nil)
    response = { success: true }
    response.merge!(data) if data.present?
    render json: response, status: :created
  end

  def unprocessable_entity(error = nil)
    error = 'Invalid request' if error.blank?
    render json: { success: false, error: error }, status: :unprocessable_entity
  end

  def not_found(error = nil)
    error = 'Not found' if error.blank?
    render json: { success: false, error: error }, status: :not_found
  end

  def internal_server_error(error = nil)
    error = 'Internal Server Error' if error.blank?
    render json: { success: false, error: error }, status: :internal_server_error
  end

  def unauthorized(error = nil)
    error = 'Unauthorized' if error.blank?
    render json: { success: false, error: error }, status: :unauthorized
  end

  def invalid_application_version(error = nil)
    error = 'Old application version' if error.blank?
    render json: { success: false, error: error }, status: :gone
  end
end
