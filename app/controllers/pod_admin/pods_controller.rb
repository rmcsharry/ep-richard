class PodAdmin::PodsController < PodAdminController

  layout 'pod_admin_signup'
  
  # Note: there is no index because PodAdmins can only see their own Pod
  def new
    @pod = Pod.new
  end

  def create
    @pod = Pod.new(pod_params)
    if @pod.save
      redirect_to admin_pods_path
    else
      render 'new'
    end
  end

  def edit
    @pod = Pod.find(params[:id])
  end

  def update
    pod = Pod.find(params[:id])
    pod.update!(pod_params)
    redirect_to admin_pods_path
  end

  def destroy
    pod = Pod.find(params[:id])
    pod.delete
    redirect_to admin_pods_path
  end

  private

    def pod_params
      params.require(:pod).permit(:name, :description)
    end

end
