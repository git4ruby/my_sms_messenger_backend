# rubocop:todo all

# Custom SSL context for MongoDB Atlas connection
if Rails.env.production?
  require 'openssl'
  require 'mongo'

  # Patch OpenSSL defaults globally for MongoDB connections
  OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:verify_mode] = OpenSSL::SSL::VERIFY_NONE
  OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:min_version] = OpenSSL::SSL::TLS1_2_VERSION

  # Patch the Mongo driver's SSL context creation
  Mongo::Socket::SSL.class_eval do
    private

    def create_context(options = {})
      context = OpenSSL::SSL::SSLContext.new
      context.verify_mode = OpenSSL::SSL::VERIFY_NONE
      context.min_version = OpenSSL::SSL::TLS1_2_VERSION
      context.max_version = OpenSSL::SSL::TLS1_3_VERSION
      # Disable all SSL/TLS compression to avoid CRIME attacks
      context.options |= OpenSSL::SSL::OP_NO_COMPRESSION if defined?(OpenSSL::SSL::OP_NO_COMPRESSION)
      context
    end
  end

  Rails.logger.info "OpenSSL Version: #{OpenSSL::OPENSSL_VERSION}"
  Rails.logger.info "OpenSSL Library Version: #{OpenSSL::OPENSSL_LIBRARY_VERSION}"
end

Mongoid.configure do
  target_version = "9.0"

  # Load Mongoid behavior defaults. This automatically sets
  # features flags (refer to documentation)
  config.load_defaults target_version

  # It is recommended to use config/mongoid.yml for most Mongoid-related
  # configuration, whenever possible, but if you prefer, you can set
  # configuration values here, instead:
  # 
  #   config.log_level = :debug
  #
  # Note that the settings in config/mongoid.yml always take precedence,
  # whatever else is set here.
end
 
# Enable Mongo driver query cache for Rack
# Rails.application.config.middleware.use(Mongo::QueryCache::Middleware)
 
# Enable Mongo driver query cache for ActiveJob
# ActiveSupport.on_load(:active_job) do
#   include Mongo::QueryCache::Middleware::ActiveJob
# end
