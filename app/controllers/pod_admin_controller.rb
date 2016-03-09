class PodAdminController < ApplicationController
  include FlashNoticeHelper
  
  before_filter :pod_admin_login_required
  layout 'admin'

  def index
    redirect_to pod_admin_dashboard_path if current_admin.pod && current_admin.pod.go_live_date
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

  def dashboard
    @pod = current_admin.pod
    
    if @pod.go_live_date
      flash[:notice] = build_flash_comment(@pod.latest_comment)
    end  
  end
  
end
