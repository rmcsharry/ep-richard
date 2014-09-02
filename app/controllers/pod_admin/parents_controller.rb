class PodAdmin::ParentsController < PodAdminController

  def new
    @parent = Parent.new
  end

  def create
    @parent = Parent.new(parent_params)
    @parent.pod = current_admin.pod

    if @parent.save
      redirect_to pod_admin_path
    else
      render 'new'
    end
  end

  private

    def parent_params
      params.require(:parent).permit(:name, :phone)
    end


end
