class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create
  
  def new
    @user = User.new
  end
 
  def create
    logout_keeping_session!
    if using_open_id?
      authenticate_with_open_id(params[:openid_url], :return_to => open_id_create_url, 
        :required => [:nickname, :email]) do |result, identity_url, registration|
        if result.successful?
          create_new_user(:identity_url => identity_url, :login => registration['nickname'], :email => registration['email'])
        else
          failed_creation(result.message || t(:user_something_wrong))
        end
      end
    else
      create_new_user(params[:user])
    end
  end
  
  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = t(:user_singup_complete)
      redirect_to login_path
    when params[:activation_code].blank?
      flash[:error] = t(:user_activation_missing)
      redirect_back_or_default(root_path)
    else 
      flash[:error]  = t(:user_activation_invalid)
      redirect_back_or_default(root_path)
    end
  end
  
  protected
  
  def create_new_user(attributes)
    @user = User.new(attributes)
    if @user && @user.valid?
      if @user.not_using_openid?
        @user.register!
      else
        @user.register_openid!
      end
    end
    
    if @user.errors.empty?
      successful_creation(@user)
    else
      failed_creation
    end
  end
  
  def successful_creation(user)
    redirect_back_or_default(root_path)
    flash[:notice] = t(:user_signup_thanks)
    flash[:notice] << " " + t(:user_sending_activation) if @user.not_using_openid?
    flash[:notice] << " " + t(:user_openid_enabled) unless @user.not_using_openid?
  end
  
  def failed_creation(message = t(:user_signup_error))
	@user = User.new if @user.nil?
    flash[:error] = message
    render :action => :new
  end
end
