class AdminController < ApplicationController
  before_filter :admin_login_required

  def index
  end

  def parents_import
    @pod = Pod.find(params[:pod_id])
    if @pod.nil?
      flash[:notice] = "Pod not found. Import failed."
    else
      count = Parent.import(params[:file], @pod.id)
      flash[:notice] = "#{count} parents imported to #{@pod.name}"
    end
    redirect_to admin_pods_url
  end
end
