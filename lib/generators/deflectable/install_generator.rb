module Deflectable::Generators
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def copy_config_yaml
      template "deflectable.yml", "config/deflectable.yml"
    end

    def copy_forbidden_page
      template "403.html", "public/403.html"
    end
  end
end if defined?(Rails)
