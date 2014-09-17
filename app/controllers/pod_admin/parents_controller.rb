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
      flash[:notice] = "Ok! Added #{@parent.name.split[0]} to the pod."
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
    flash[:notice] = "#{parent.name.split[0]} updated."
    redirect_to pod_admin_path
  end

  def destroy
    parent = Parent.find(params[:id])
    parent_name = parent.name.split[0]
    if parent.delete
      flash[:notice] = "Ok, deleted #{parent_name}!"
    else
      flash[:notice] = "Hm. That didn't seem to work."
    end
    redirect_to pod_admin_path
  end

  def send_welcome_sms
    @parent = Parent.find(params[:id])

    begin
      @parent.send_welcome_sms
    rescue Twilio::REST::RequestError => e
      flash[:notice] = "Hm. That didn't work. Please contact EasyPeasy and tell them there was an error with code #{e.code}. Sorry for the inconvenience."
    else
      flash[:notice] = "SMS sent!"
    end

    redirect_to pod_admin_path
  end

  private

    def parent_params
      params.require(:parent).permit(:name, :phone)
    end
end
