admin_email = YAML.load_file("#{RAILS_ROOT}/config/settings.yml")[RAILS_ENV]['admin_email']
ExceptionNotification::Notifier.exception_recipients = admin_email