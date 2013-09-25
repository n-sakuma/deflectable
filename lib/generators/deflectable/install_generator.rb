module Deflectable::Generators
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def copy_config_yaml
      template "deflectable.yml", "config/deflectable.yml"
    end
  end
end if defined?(Rails)
