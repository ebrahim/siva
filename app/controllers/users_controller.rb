class UsersController < ApplicationController
	skip_before_filter :verify_authenticity_token, :only => :create
	require_role :admin, :except => [ :new, :create, :show, :edit, :update, :passwd, :destroy, :activate ]
	require_role :editor, :except => [ :new, :create, :activate ]

	def index
		@users = User.paginate :page => params[:page], :conditions => "state != 'deleted'", :order => :login
	end

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

	def show
		@user = User.find params[:id]
		redirect_to :logout unless current_user && @user && (current_user.id == @user.id || current_user.has_role?('admin'))
	end

	def edit
		@user = User.find params[:id]
		redirect_to :logout unless current_user && @user && (current_user.id == @user.id || current_user.has_role?('admin'))
	end

	def passwd
		@user = User.find params[:id]
		redirect_to :logout unless current_user && @user && (current_user.id == @user.id || current_user.has_role?('admin'))
	end

	def suspend
		@user = User.find params[:id]

		if current_user && current_user.has_role?('admin') && @user && !@user.has_role?('admin') && @user.suspend!
			flash[:notice] = t :user_was_suspended
		else
			flash[:error] = t :user_fail
		end
		redirect_to :action => :index
	end

	def unsuspend
		@user = User.find params[:id]

		if current_user && current_user.has_role?('admin') && @user && @user.unsuspend!
			flash[:notice] = t :user_was_unsuspended
		else
			flash[:error] = t :user_fail
		end
		redirect_to :action => :index
	end

	def update
		@user = User.find params[:id]

		if @user.update_attributes params[:user]
			flash[:notice] = t :user_updated
			redirect_to @user
		else
			flash[:error] = @user.errors.full_messages
			redirect_to :action => :edit
		end
	end

	def destroy
		@user = User.find params[:id]
		if current_user && @user && (current_user.id == @user.id || current_user.has_role?('admin')) && !@user.has_role?('admin')
			if @user.deleted_at		# If already deleted
				@user.destroy		# Purge
			else
				@user.delete!
			end
			flash[:notice] = t :user_removed
		else
			flash[:error] = t :user_fail
		end
		if current_user && current_user.has_role?('admin')
			redirect_to :action => :index
		else
			redirect_to :logout
		end
	end

	def activate
		logout_keeping_session!
		user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
		case
		when !params[:activation_code].blank? && user && !user.active?
			user.activate!
			user.suspend!
			flash[:notice] = t :user_singup_complete
		when params[:activation_code].blank?
			flash[:error] = t :user_activation_missing
		else
			flash[:error]  = t :user_activation_invalid
		end
		redirect_back_or_default root_path
	end
  
	protected
  
	def create_new_user(attributes)
		@user = User.new(attributes)
		if @user && @user.valid?
			if @user.not_using_openid?
				@user.register!
			else
				@user.register_openid!
				@user.suspend!
			end
		end

		@user.roles << Role.find_by_name('editor')
    
		if @user.errors.empty?
			successful_creation @user
		else
			failed_creation
		end
	end
  
	def successful_creation(user)
		flash[:notice] = t(:user_signup_thanks)
		if @user.not_using_openid?
			flash[:notice] << " " + t(:user_sending_activation)
		else
			flash[:notice] << " " + t(:user_openid_enabled)
		end
		redirect_back_or_default root_path
	end
  
	def failed_creation(message = t(:user_signup_error))
		@user = User.new if @user.nil?
		flash[:error] = message
		render :action => :new
	end
end
