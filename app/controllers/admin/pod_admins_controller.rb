class Admin::PodAdminsController < AdminController

  def index
    @pod_admins = PodAdmin.all
  end

  def new
    @pod_admin = PodAdmin.new
  end

  def create
    @pod_admin = PodAdmin.new(pod_admin_params)
    if @pod_admin.save
      redirect_to admin_pod_admins_path
    else
      render 'new'
    end
  end

  def edit
    @pod_admin = PodAdmin.find(params[:id])
  end

  def update
    @pod_admin = PodAdmin.find(params[:id])
    @pod_admin.update(pod_admin_params)

    if @pod_admin.valid?
      redirect_to admin_pod_admins_path
    else
      render 'edit'
    end
  end

  def destroy
    pod_admin = PodAdmin.find(params[:id])
    pod_admin.delete
    redirect_to admin_pod_admins_path
  end

  private

    def pod_admin_params
      params.require(:pod_admin).permit(:email, :password, :pod_id)
    end

end
