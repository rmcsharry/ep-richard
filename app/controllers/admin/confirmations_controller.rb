class Admin::ConfirmationsController < Devise::ConfirmationsController
  skip_before_action :verify_authenticity_token, only: [:create]
  
  layout 'pod_admin/signup'
  # Note: in this controller, the resource_class is Admin (since that is our Devise user class)
  
  def create
    # create is called from a separate sign-up application, so there will be no authenticity token, this is a pure API call
    # this is also why email is not in the permitted_params, because it could possibly be changed when show/confirm methods fire
    if Admin.exists?(email: params[:email])
      notify_existing_admin
      render json: {head: :not_modified}, status: :not_modified, content_type: 'json'    
    else
      new_admin = Admin.new(email: params[:email])
      if new_admin.valid?
        new_admin.save
        render json: {head: :created}, status: :created, content_type: 'json'
      else
        render json: new_admin.errors, status: 422, content_type: 'json'
      end
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
    
    # NB: At this point, our resource is just an Admin, so resource.valid will only fire validations on the Admin model
    if resource.valid? && resource.password_match?
      self.resource.confirm # this triggers a save of the resource (without firing validations, so we now have a PodAdmin without a Pod!)
      resource.type = 'PodAdmin' # set the type before redirecting, this will get saved by the sign_in commit call
      sign_in_and_redirect resource
    else
      render :action => 'show'
    end
  end

 private
   def permitted_params
     params.require(resource_name).permit(:confirmation_token, :preferred_name, :password, :password_confirmation)
   end
   
   def notify_existing_admin
     existing_admin = Admin.find_by(email: params[:email])
     existing_admin.resend_confirmation_instructions if existing_admin.confirmed?
     existing_admin.send_account_already_exists_email
   end
end