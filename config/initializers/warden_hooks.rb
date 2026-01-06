Warden::Manager.after_set_user do |user, auth, opts|
  scope = opts[:scope]
  Rails.logger.info "Warden set user: #{user&.email} (scope: #{scope})"
end

Warden::Manager.before_failure do |env, opts|
  Rails.logger.error "Warden authentication failed: #{opts.inspect}"
  Rails.logger.error "Headers: #{env['HTTP_AUTHORIZATION']&.slice(0, 50)}"
end

Warden::Manager.after_authentication do |user, auth, opts|
  Rails.logger.info "After authentication: #{user&.email}"
end
