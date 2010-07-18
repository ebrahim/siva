class UserMailer < ActionMailer::Base
	def signup_notification(user)
		setup_email user
		@subject << 'Your account has been created'
		@body[:url] = "#{APP_CONFIG[:site_url]}/activate/#{user.activation_code}"
	end

	def activation(user)
		setup_email user
		@subject << 'Your email address is verified'
	end

	def unsuspend_notification(user)
		setup_email user
		@subject << 'Your account has been activated'
		@body[:url] = "#{APP_CONFIG[:site_url]}/login"
	end

	def review_notification(user, admin)
		setup_email admin
		@subject << 'A new account is waiting to be reviewed'
		@body[:url] = "#{APP_CONFIG[:site_url]}/users/#{user.id}"
	end

	protected

	def setup_email(user)
		@recipients = "#{user.email}"
		@from = APP_CONFIG[:admin_email]
		@subject = "[#{APP_CONFIG[:site_name]}] "
		@sent_on = Time.now
		@body[:user] = user
	end
end
