class PodAdminController < ApplicationController
  before_filter :pod_admin_login_required
  layout 'admin'

  def index
  end

  def set_go_live_date_for_pod
    @pod = Pod.find(params[:id])

    if @pod.set_go_live_date
      flash[:notice] = "Hooray! Your pod is live!"
    else
      flash[:notice] = "Hm. That didn't work. Please contact EasyPeasy for assistance."
    end
    redirect_to pod_admin_path
  end

end
