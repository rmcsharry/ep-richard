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
      redirect_to admin_games_path
    else
      render 'new'
    end
  end

  def edit
    @pod_admin = PodAdmin.find(params[:id])
  end

  def update
    pod_admin = PodAdmin.find(params[:id])
    if pod_admin.valid?
      pod_admin.update!(pod_admin_params)
      redirect_to admin_pod_admins_path
    else
      render 'edit'
    end
  end

  private

    def pod_admin_params
      params.require(:pod_admin).permit(:email, :password)
    end


end
