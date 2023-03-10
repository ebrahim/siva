class UserObserver < ActiveRecord::Observer
	def after_create(user)
		if user.not_using_openid?
			UserMailer.deliver_signup_notification user
		else
			deliver_activation user
		end
	end

	def after_save(user)
		deliver_activation user if user.recently_activated? && user.not_using_openid?
		UserMailer.deliver_unsuspend_notification user if user.recently_unsuspended?
	end

	protected

	def deliver_activation(user)
		UserMailer.deliver_activation user
		UserMailer.deliver_review_notification user, User.find_by_login('admin')
	end
end
