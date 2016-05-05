class PodAdmin::SignupController < PodAdminController
  include Wicked::Wizard
  steps :step01, :step02, :step03
  @@sms_results = {}
    
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
        send_sms_to_first_parent(@pod.parents.first)# since step 2 succeeded, we just saved the pod with possibly one parent, so send them the sms
        2.times{ @pod.parents.build } # this allows 2 sets of fields to show so the user can add up to 2 parents
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
        if try_build_parents && !@pod.valid?
          @pod.parents.build
        end
        render_wizard @pod
    end
  end
  
  private
    def send_sms_to_first_parent(parent)
      return if parent.nil?
      @@sms_results = { parent.name => try_sending_welcome_sms(parent) }
    end
    
    # TODO: Put this into a helper and share it with similar code in parent model     
    def try_sending_welcome_sms(parent)
      begin
        parent.send_welcome_sms
      rescue Twilio::REST::RequestError => e
        return false
      else
        parent.log_welcome_sms_sent
        return true
      end
    end
    
    def finish_wizard_path
      @pod = Pod.find(session[:pod_id])
      @pod.inactive_date = Date.today + 14.days # free trial ends at start of 15th day (ie. midnight of the 14th day)
      @pod.set_go_live_date
      # Now the wizard is finished, send the sms to the parents that were added (if any)
      if current_admin.pod.parents.count > 0
        try_to_send_sms_to_new_parents
        process_errors
      end
      pod_admin_path
    end
 
    def try_to_send_sms_to_new_parents
      current_admin.pod.parents.where('welcome_sms_sent = ?', false).each do |parent|
        @@sms_results.store(parent.name, try_sending_welcome_sms(parent))
      end
    end
    
    def process_errors
      sms_errors = @@sms_results.select{|k,v| v == false}
      if sms_errors.count == 0
        flash[:success] = "Awesome, these parents have now received a text message to their phone."
      else
        sms_errors = @@sms_results.map{|k,v| k if v == false}.compact
        formatted_errors = sms_errors.map{|s| "#{s}"}.join(', ')
        flash[:danger] = "Whoops! Something went wrong - please try sending again using the Parents menu. The SMS did not get sent for: #{formatted_errors}."
      end
    end
 
    def pod_params
      params.require(:pod).permit(:id, :name, parents_attributes: [:id, :name, :phone])
    end
    
    def try_build_parents
      is_blank_submitted = false
      pod_params[:parents_attributes].each do |k,v| 
        if v[:name].blank? && v[:phone].blank?
          v.merge!({:_destroy => '1'}) # when the pod saves, this empty record will be discarded
          is_blank_submitted = true # since we discarded an empty record, we need to put it back in the view (only if validations fail on the other record)
        else
          @pod.parents.build(pod_params[:parents_attributes][k])
        end
      end
      return is_blank_submitted
    end
end
