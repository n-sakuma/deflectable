$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "deflectable/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "deflectable"
  s.version     = Deflectable::VERSION
  s.authors     = ["Naohiro Sakuma"]
  s.email       = ["nao.bear@gmail.com"]
  s.homepage    = "https://github.com/n-sakuma/deflectable"
  s.summary     = "Access controll by IP Address."
  s.description = "Access controll by IP Address."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.0"

  s.add_development_dependency "sqlite3"
end
