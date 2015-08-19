require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'sprockets/railtie'

Bundler.require(*Rails.groups)

module Amaterasu
  class Application < Rails::Application
    config.time_zone = 'Kyiv'
    config.active_record.default_timezone = :local

    config.autoload_paths += %W(#{config.root}/lib)

    config.action_view.embed_authenticity_token_in_remote_forms = true

    config.serve_static_assets = true

    config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)
  end
end
