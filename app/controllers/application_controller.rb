class ApplicationController < ActionController::Base
  #before_action :authenticate_user!
  before_filter :set_locale
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authenticate_active_admin_user!
    authenticate_user!
    unless current_user.admin?
      flash[:alert] = "You are not authorized to access this resource!"
      redirect_to root_path
    end
  end

  def set_locale
    #puts params[:locale]
    if params[:locale].present?
      I18n.locale = params[:locale]
    else
      puts "postavio sam locale iz browsera!"
      I18n.locale = extract_locale_from_accept_language_header.include? "hr" ? "hr" : "en"
    end
  end

  def default_url_options(options = {})
    {locale: I18n.locale}
  end

  private

  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  end
end
