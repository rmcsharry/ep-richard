class Admin::ConfirmationsController < Devise::ConfirmationsController
  skip_before_action :verify_authenticity_token, only: [:create]
  
  layout 'pod_admin/signup'
  # Note: in this controller, the resource_class is Admin (since that is our Devise user class)
  
  def create
    # create is called from a separate sign-up application, so there will be no authenticity token, this is a pure API call
    email_address = params[:email]
    if email_address.nil?
      render json: {account: 'Not created'}, status: :unprocessible_entity, content_type: 'json'
    else
      Admin.create!(email: email_address)
      render json: {head: :ok}, status: :created, content_type: 'json'
    end
  end
  
  def show
    if params[:confirmation_token].present?
      @original_token = params[:confirmation_token]
    elsif params[resource_name].try(:[], :confirmation_token).present?
      @original_token = params[resource_name][:confirmation_token]
    end
    self.resource = resource_class.find_or_initialize_with_error_by(:confirmation_token, @original_token)  
    if resource.confirmed?
      flash[:warning] = "That account has already been confirmed. Please login."
      redirect_to admin_login_path
    end
    super if resource.nil?
  end

  def confirm
    @original_token = params[resource_name].try(:[], :confirmation_token)
    self.resource = resource_class.find_or_initialize_with_error_by(:confirmation_token, @original_token)    
    resource.assign_attributes(permitted_params) unless params[resource_name].nil?

    if resource.valid? && resource.password_match?
      resource.type = 'PodAdmin'
      self.resource.confirm # this triggers a save of the resource (without firing validations, so we now have a PodAdmin without a Pod!)
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