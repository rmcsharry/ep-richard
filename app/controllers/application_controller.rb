class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def admin_logged_in?
    signed_in? && current_admin.type == 'EasyAdmin'
  end

  def pod_admin_logged_in?
    signed_in? && current_admin.type == 'PodAdmin'
  end

  def admin_login_required
    redirect_to admin_login_path unless admin_logged_in?
  end

  def pod_admin_login_required
    redirect_to admin_login_path unless pod_admin_logged_in?
  end

  private

  # Overwrite the sign_in and sign_out redirect path methods
  def after_sign_out_path_for(resource_or_scope)
    admin_login_path
  end
  def after_sign_in_path_for(resource_or_scope)
    if resource_or_scope.type == 'PodAdmin'
      pod_admin_path
    else
      admin_path
    end
  end

end
