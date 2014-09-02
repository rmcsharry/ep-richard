class Admin::PodAdminsController < AdminController

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

  private

    def pod_admin_params
      params.require(:pod_admin).permit(:email, :password)
    end


end
