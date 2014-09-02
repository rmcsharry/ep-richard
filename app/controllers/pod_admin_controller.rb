class PodAdminController < ApplicationController
  before_filter :pod_admin_login_required

  def index
    render 'pod_admin/index', layout: 'admin'
  end

end
