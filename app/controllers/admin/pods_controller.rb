class Admin::PodsController < AdminController
  include ParentHelper

  def index
    @pods = Pod.order('LOWER(name)')
  end

  def new
    @pod = Pod.new
  end

  def show
    @pod = Pod.find(params[:id])
    @parents = @pod.parents.order('LOWER(name)')

    year = Date.today.year.to_i - 6
    @year = params[:year].presence || year.to_s + '-01-01'
    @schoolId = @pod.school_id
    @newParents = Array.new

    if !@schoolId.blank? && !params[:year].blank?
      @newParents = get_parents
    end

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

  def create_multiple
    @pod = Pod.find(params[:id])
    count = 0
    params['parents'].each_with_index do |parent, i|
      if parent.has_key?('add')
        @parent = Parent.new({name: parent['name'], phone: parent['phone']})
        @parent.pod = @pod
        if !@parent.save
          puts @parent.errors.full_messages
        end
        count = i
      end
    end
    flash[:success] = "#{count+1} new parent(s) were added to your pod"
    redirect_to admin_pod_path
  end

  def edit
    @pod = Pod.find(params[:id])
    @parents = @pod.parents.order('LOWER(name)')
  end

  def update
    @pod = Pod.find(params[:id])
    @pod.update!(pod_params)
    if @pod.valid?
      flash[:success] = "Pod successfully updated!"
      redirect_to edit_admin_pod_path(params['id'])
    else
      render 'edit'
    end
  end

  def update_multiple
    params['parent'].each do |k,v|
      @parent = Parent.find(k.to_i)
      @parent.update_attributes(v)
    end
    flash[:success] = "Parents updated"
    redirect_to edit_admin_pod_path(params['id'])
  end

  def destroy
    pod = Pod.find(params[:id])
    pod.delete
    flash[:success] = "Pod successfully deleted!"
    redirect_to admin_pods_path
  end

  private

    def pod_params
      params.require(:pod).permit(:name, :description, :go_live_date, :inactive_date, :is_test, :school_id)
    end

    def parent_params
      params.permit(:name, :phone)
    end

end
