class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  after_filter :set_csrf_cookie_for_ng
  before_action :check_account_permission

  def current_account
    @current_account ||= Account.find_by_auth_token(cookies[:auth_token]) if cookies[:auth_token]
  end

  helper_method :current_account

  protected

  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  def verified_request?
    super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
  end

  def check_account_permission
    redirect_to signin_path unless current_account
  end
end
