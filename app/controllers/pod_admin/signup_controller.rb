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
        @submit_text = "Send"
      when :step03
        @pod = Pod.find(session[:pod_id])
        2.times{ @pod.parents.build } # this allows to sets of fields to show so the user can add up to 2 parents
        @submit_text = "Go!"
    end
    render_wizard
  end
  
  def update
    case step
      when :step01
        if session[:pod_id].nil?
          @pod = Pod.new(pod_params)
        else
          @pod = Pod.find(session[:pod_id]) # if the user hit back button, retrieve the same pod_id
        end
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
        is_one_record_blank = try_build_parents
        
        if @pod.valid?
          @pod.save
          redirect_to pod_admin_path
        else
          @pod.parents.build if is_one_record_blank
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
    
    def delete_ids! x
      # recursive function to remove embedded id records
      x.reject!{|k,v| 'id' == k} if x.is_a? Hash
      x.each{|k,v| delete_ids! x[k]} if x.is_a? Hash
    end
    
    def try_build_parents
      is_blank_submitted = false
      params = delete_ids! pod_params # we need to remove the record that was created in step 2 or it will show on the form
      params[:parents_attributes].each do |k,v| 
        if v[:name].blank? && v[:phone].blank?
          v.merge!({:_destroy => '1'}) # when the pod saves, this empty record will be discarded
          is_blank_submitted = true # since we discarded an an empty submission, we can put it back in the view should validations fail on the other record
        else
          @pod.parents.build(params[:parents_attributes][k])
        end
      end
      return is_blank_submitted
    end
end
