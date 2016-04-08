class PodAdmin::SignupController < PodAdminController
  include Wicked::Wizard
  steps :step01, :step02, :step03
  
  layout 'pod_admin/signup'
  
  def show
    case step
      when :step01
        @pod = Pod.new
      when :step02
        @pod = Pod.find(session[:pod_id])
        @pod.parents.build
      when :step03
        @pod = Pod.find(session[:pod_id])
        2.times{ @pod.parents.build }
    end
    render_wizard
  end
  
  def update
    case step
      when :step01
        @pod = Pod.new(pod_params)
        @pod.attributes = pod_params
        if @pod.valid?
          @pod.save!
          current_admin.pod = @pod
          session[:pod_id] = @pod.id # store the id so we can add parents to it in following steps
        end
        render_wizard @pod # saves the pod, triggers validations
      when :step02
        @pod = Pod.find(session[:pod_id])
        pod_params[:parents_attributes].each {|k,_| @pod.parents.build(pod_params[:parents_attributes][k])}
        render_wizard @pod # saves the parent, triggers validations
      when :step03
        @pod = Pod.find(session[:pod_id])
        pod_params[:parents_attributes].each {|k,_| @pod.parents.build(pod_params[:parents_attributes][k])}
        #@pod.parents.build(pod_params[:parents_attributes]['0'])
        #@pod.parents.build(pod_params[:parents_attributes]['1'])
        Rails.logger.info @pod.parents
        if @pod.save
          redirect_to pod_admin_path
        else
          render_wizard @pod
        end
    end
  end
  
  private
    def finish_wizard_path
      pod_admin_path
    end
 
    def pod_params
      params.require(:pod).permit(:id, :name, parents_attributes: [:id, :name, :phone])
    end

    def parent_params
      # This is so we can create a parent separate from a pod in step 2
      params.require(:parent).permit(:name, :phone)
    end
end
