class PodAdmin::ParentsController < PodAdminController

  def show
    @parent = Parent.find(params[:id])
  end

  def new
    @parent = Parent.new
  end

  def create
    @parent = Parent.new(parent_params)
    @parent.pod = current_admin.pod

    if @parent.save
      redirect_to pod_admin_parent_path(@parent)
    else
      render 'new'
    end
  end

  def edit
    @parent = Parent.find(params[:id])
  end

  def update
    parent = Parent.find(params[:id])
    parent.update!(parent_params)
    redirect_to pod_admin_path
  end

  def destroy
    parent = Parent.find(params[:id])
    parent.delete
    redirect_to pod_admin_path
  end

  private

    def parent_params
      params.require(:parent).permit(:name, :phone)
    end
end
