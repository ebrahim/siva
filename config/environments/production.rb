# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Enable threaded mode
# config.threadsafe!

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

# Restful Authentication
REST_AUTH_SITE_KEY = 'f5945d1c74d3502f8a3de8562e5bf21fe3fec887'
REST_AUTH_DIGEST_STRETCHES = 10

config.action_mailer.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address => "mail.mohammadi.ir",
  :domain => "ebrahim.ir",
  :port => 587,
  :user_name => "siva@ebrahim.ir",
  :password => "sivajoondoosetdarim!",
  :authentication => :plain,
  :tls => true
}
