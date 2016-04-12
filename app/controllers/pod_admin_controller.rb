class PodAdminController < ApplicationController
  include FlashNoticeHelper
  
  before_filter :pod_admin_login_required
  layout 'admin'

  def index
    if current_admin.pod && current_admin.pod.go_live_date
      flash.now[:notice] = build_flash_comment(current_admin.pod.latest_comment)
      # TODO: this is temporary, update later to show dashboard
      # redirect_to pod_admin_dashboard_path
    elsif current_admin.pod.nil?
      # this pod admin has not finished creating their pod (ie they signed-up via other website and admin/confirmations/create)
      redirect_to pod_admin_signup_path(id: 'step01')
    end
  end

  def analytics
    @pod = current_admin.pod
  end

  def comments
    @comments = Comment.where(pod_id: current_admin.pod)
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
