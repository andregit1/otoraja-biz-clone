require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.

    I18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{erb,yml}').to_s]

    config.load_defaults 5.2

    I18n.default_locale = :id

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.paths.add 'lib/add_on', eager_load: true
  end
end
