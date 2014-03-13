source 'https://rubygems.org'

ruby '2.0.0'

gem 'rails', '~> 4.0'
gem 'rake'
gem 'pg'
gem 'activerecord-import'

gem 'rubyzip'
gem 'uuidtools'
gem 'jbuilder', '~> 1.2'
gem 'haml-rails'
gem 'dalli'

group :production do
  gem 'rails_12factor'
  gem 'memcachier'
  gem 'unicorn', '~> 4.8'
  gem 'newrelic_rpm'
end

group :development, :test do
  gem 'pry-rails'
  gem 'semver'
  gem 'rspec-rails', '~> 3.0.0.beta'
  gem 'factory_girl_rails', '~> 4.3.0'
  gem 'metric_fu'
  gem 'database_cleaner'
  gem 'rest-client', '~> 1.6', require: false
end
