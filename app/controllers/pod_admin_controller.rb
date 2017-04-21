class PodAdminController < ApplicationController
  include ParentHelper
  include GreetingHelper

  before_filter :pod_admin_login_required
  before_filter :is_trial_expired, except: [:expired]
  layout 'admin'

  def index
    if current_admin.pod && !current_admin.pod_id.blank?
      flash.now[:info] = current_admin.pod.most_recent_comment_notice("/pod_admin/games/")
      create_login_greeting
      # TODO: this is temporary, update later to show dashboard
      # redirect_to pod_admin_dashboard_path
    else
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
      flash[:success] = "Hooray! Your pod is live!"
    else
      flash[:danger] = "Hm. That didn't work. Please contact EasyPeasy for assistance."
    end
    redirect_to pod_admin_path
  end

  def expired
    # If pod is active, prevent showing the expired page
    redirect_to pod_admin_path if current_admin.pod && current_admin.pod.is_active?
  end

  private

    def is_trial_expired
      redirect_to pod_admin_expired_path if current_admin.pod && !current_admin.pod.is_active?
    end

end
