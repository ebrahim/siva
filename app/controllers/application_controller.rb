class ApplicationController < ActionController::Base
	include ExceptionNotification::Notifiable
	include AuthenticatedSystem
	include RoleRequirementSystem

	helper :all # include all helpers, all the time
	protect_from_forgery # :secret => 'b0a876313f3f9195e9bd01473bc5cd06'
	filter_parameter_logging :password, :password_confirmation
	rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  
	before_filter :set_locale_from_url

	def index
		redirect_to :controller => :synonymies, :action => :index
	end

	protected
  
	# Automatically respond with 404 for ActiveRecord::RecordNotFound
	def record_not_found
		render :file => File.join(RAILS_ROOT, 'public', '404.html'), :status => 404
	end
end

