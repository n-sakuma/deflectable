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

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency 'rack', '>= 0.9.1'

  s.add_development_dependency "pry"
  s.add_development_dependency "rake", '> 0'
  s.add_development_dependency "rspec", '>= 2'
  s.add_development_dependency "rack-test", '> 0'

  # s.add_development_dependency "mocha", '>= 0'
  # s.add_development_dependency "guard-rspec"
  # s.add_development_dependency "sinatra", '> 1.0'
  # s.add_dependency "rails", "~> 4.0.0"
  # s.add_development_dependency "sqlite3"
  # s.add_development_dependency "bundler", '~> 1.1.rc'
end
