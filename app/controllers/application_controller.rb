class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def after_sign_in_path_for(resource)
    # Điều hướng cho người dùng Supper Admin, Admin, User
    if resource.group.level == 1 || resource.group.level == 2
      admin_dashboards_path
    else
      root_path
    end
  end

  before_action :set_locale
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
