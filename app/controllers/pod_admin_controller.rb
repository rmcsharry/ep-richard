class PodAdminController < ApplicationController
  before_filter :pod_admin_login_required
  layout 'admin'

  def index
    if current_admin.pod
      @parents = current_admin.pod.parents.order("LOWER(name)")
    end
    render 'pod_admin/index'
  end

end
