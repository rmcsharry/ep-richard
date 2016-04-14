class AdminController < ApplicationController
  before_filter :admin_login_required

  def index
  end

  def parents_import
    @pod = Pod.find(params[:pod_id])
    if params[:file].blank?
      flash[:danger] = "No file found - please select a CSV file."
    else
      Rails.logger.info params[:file]
      count = Parent.import(params[:file], @pod.id)
      flash[:success] = "#{count} parents imported to #{@pod.name}"
    end
    redirect_to edit_admin_pod_path(@pod)
  end
end
