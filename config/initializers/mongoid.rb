# rubocop:todo all

# Custom SSL context for MongoDB Atlas connection
if Rails.env.production?
  require 'openssl'
  require 'mongo'

  # Create a custom SSL context that works with MongoDB Atlas
  ssl_context = OpenSSL::SSL::SSLContext.new
  ssl_context.verify_mode = OpenSSL::SSL::VERIFY_NONE
  ssl_context.set_params(
    verify_mode: OpenSSL::SSL::VERIFY_NONE,
    min_version: OpenSSL::SSL::TLS1_2_VERSION
  )

  # Monkey patch the Mongo client to use our custom SSL context
  module Mongo
    class Socket
      class SSL < Socket
        private

        def create_context(options = {})
          context = OpenSSL::SSL::SSLContext.new
          context.verify_mode = OpenSSL::SSL::VERIFY_NONE
          context.set_params(
            verify_mode: OpenSSL::SSL::VERIFY_NONE,
            min_version: OpenSSL::SSL::TLS1_2_VERSION
          )
          context
        end
      end
    end
  end
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
