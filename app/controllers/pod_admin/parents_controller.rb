class PodAdmin::ParentsController < PodAdminController

  def index
    if current_admin.pod
      @parents = current_admin.pod.parents.order("LOWER(name)")
    end
  end

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
      flash[:success] = "Ok! Added #{@parent.name.split[0]} to the pod."
      redirect_to pod_admin_parent_path(@parent)
    else
      render 'new'
    end
  end

  def edit
    @parent = Parent.find(params[:id])
  end

  def update
    @parent = Parent.find(params[:id])
    
    @parent.update_attributes(parent_params)

    if @parent.save
      flash[:success] = "#{@parent.name.split[0]} updated."
      redirect_to pod_admin_path
    else
      render 'edit'
    end
  end

  def destroy
    parent = Parent.find(params[:id])
    parent_name = parent.name.split[0]
    if parent.delete
      flash[:success] = "Ok, deleted #{parent_name}!"
    else
      flash[:danger] = "Hm. That didn't seem to work."
    end
    redirect_to pod_admin_parents_path
  end

  def send_welcome_sms
    @parent = Parent.find(params[:id])
    @parent.send_welcome_sms
    if @parent.errors.count > 0
      flash.now[:danger] = "Hm. That didn't work. Please contact EasyPeasy about the error(s) shown below. Sorry for the inconvenience."
      render 'show'
    else
      flash[:success] = "SMS sent to #{@parent.name}!"
      redirect_to pod_admin_parents_path
    end
  end

  private

    def parent_params
      params.require(:parent).permit(:name, :phone)
    end
end
