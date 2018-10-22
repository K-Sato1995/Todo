class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  if Rails.env.production?
    rescue_from Exception,                       with: :render_500
    rescue_from ActiveRecord::RecordNotFound,    with: :render_404
  end

  def render_404(exception = nil)
    logger.info "Rendering 404 with exception: #{exception.message}" if exception
    render template: 'errors/error_404', status: :not_found, layout: 'application'
  end

  def render_500(exception = nil)
    logger.info "Rendering 500 with exception: #{exception.message}" if exception
    render template: 'errors/error_500', status: :internal_server_error, layout: 'application'
  end
end
