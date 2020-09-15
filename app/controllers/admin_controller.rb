class AdminController < ActionController::Base
  layout "admin"

  include SessionsHelper

  before_action :set_locale

  add_breadcrumb I18n.t("dashboard.breadcrumbs.home"), :admin_root_path

  private

  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
  end

  def extract_locale
    parsed_locale = params[:locale]
    parsed_locale if I18n.available_locales.map(&:to_s).include? parsed_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "layouts.application.require_login"
    redirect_to admin_login_url
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "users.controller.not_found"
    redirect_to admin_root_path
  end
end
