class Admin::PodAdminsController < AdminController

  def index
    @pod_admins = PodAdmin.order(:created_at)
  end

  def new
    @pod_admin = PodAdmin.new
  end

  def create
    @pod_admin = PodAdmin.new(pod_admin_params)
    @pod_admin.type = 'PodAdmin'
    if @pod_admin.save
      flash[:success] = "New pod admin successfully added!"
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
      flash[:success] = "Pod admin successfully updated!"
      redirect_to admin_pod_admins_path
    else
      render 'edit'
    end
  end

  def destroy
    pod_admin = PodAdmin.find(params[:id])
    pod_admin.delete
    flash[:success] = "Pod admin successfully deleted!"    
    redirect_to admin_pod_admins_path
  end

  private

    def pod_admin_params
      params.require(:pod_admin).permit(:email, :name, :preferred_name, :password, :pod_id)
    end

end
