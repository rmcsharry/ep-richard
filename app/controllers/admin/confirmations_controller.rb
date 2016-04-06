class Admin::ConfirmationsController < Devise::ConfirmationsController

  layout 'admin'
  # Note: the resource_class hers is Admin (since that is our Devise user class)
  
  def show
    if params[:confirmation_token].present?
      @original_token = params[:confirmation_token]
    elsif params[resource_name].try(:[], :confirmation_token).present?
      @original_token = params[resource_name][:confirmation_token]
    end
    
    digested_token = Devise.token_generator.digest(self, :confirmation_token, @original_token)
    self.resource = resource_class.find_or_initialize_with_error_by(:confirmation_token, digested_token)  
    
    super if resource.nil? or resource.confirmed?
  end

  def confirm
    @original_token = params[resource_name].try(:[], :confirmation_token)
    digested_token = Devise.token_generator.digest(self, :confirmation_token, @original_token)
    self.resource = resource_class.find_or_initialize_with_error_by(:confirmation_token, digested_token)    
    resource.assign_attributes(permitted_params) unless params[resource_name].nil?

    if resource.valid? && resource.password_match?
      resource.type = 'PodAdmin'
      self.resource.confirm
      set_flash_message :notice, :confirmed
      Rails.logger.info resource_name
      sign_in_and_redirect resource
    else
      render :action => 'show'
    end
  end

 private
   def permitted_params
     params.require(resource_name).permit(:confirmation_token, :password, :password_confirmation)
   end
   
end