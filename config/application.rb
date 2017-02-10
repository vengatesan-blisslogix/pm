require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BlissPm
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    #  config.force_ssl = true
    
    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.secret_key = '7727c90d781aae5c88c573997c5d3514408b4044eff60185f6df969b415c4b2535dfbde2e384dc12d65a4c80baa044f95f16726252549aca81c05a703b95bf16'
    config.assets.initialize_on_precompile = false
    config.active_record.raise_in_transactional_callbacks = true
    config.web_console.whiny_requests = false
    config.web_console.development_only = false
  # SUPER INSECURE NEEDS TO BE FIXED
    config.middleware.insert_before 0, "Rack::Cors" do
      allow do
        origins '*'

        resource '*',
          :headers => :any,
          :methods => [:get, :post, :delete, :put, :options, :head],          
          :max_age => 0
      end
    end
  end
end
