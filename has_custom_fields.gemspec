$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "has_custom_fields/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "has_custom_fields"
  s.version     = HasCustomFields::VERSION
  s.authors     = ["Paul Van de Vreede"]
  s.email       = ["paul@vdvreede.net"]
  s.homepage    = "https://github.com/pvdvreede/has_custom_fields"
  s.summary     = "Rails plugin that gives any model the power of custom fields managed in the database."
  s.description = "has_custom_fields makes it easy to create custom fields for any ActiveRecord model."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 3.2.12"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'mutant'

end
