class PodAdminController < ApplicationController
  before_filter :pod_admin_login_required
  layout 'admin'

  def index
    @parents = current_admin.pod.parents
    render 'pod_admin/index'
  end

end
