class Admin::PodsController < AdminController

  def index
    @pods = Pod.order('LOWER(name)')
  end

  def new
    @pod = Pod.new
  end

  def create
    @pod = Pod.new(pod_params)
    if @pod.save
      flash[:success] = "New pod successfully added!"
      redirect_to admin_pods_path
    else
      render 'new'
    end
  end

  def edit
    @pod = Pod.find(params[:id])
  end

  def update
    @pod = Pod.find(params[:id])
    @pod.update!(pod_params)
    if @pod.valid?
      flash[:success] = "Pod successfully updated!"
      redirect_to admin_pods_path
    else
      render 'edit'
    end    
  end

  def destroy
    pod = Pod.find(params[:id])
    pod.delete
    flash[:success] = "Pod successfully deleted!"
    redirect_to admin_pods_path
  end

  private

    def pod_params
      params.require(:pod).permit(:name, :description, :inactive_date, :is_test)
    end

end
