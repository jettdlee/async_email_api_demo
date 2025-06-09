class ApplicationController < ActionController::API
  rescue_from StandardError, with: :handle_internal_error

  private

  def handle_internal_error(error)
    Rails.logger.error("Internal server error: #{error.message}\n#{error.backtrace.join("\n")}")
    render json: { error: "Internal server error. Please try again later." }, status: :internal_server_error
  end
end
