source 'https://rubygems.org'

ruby '2.0.0'
#ruby '1.9.3', engine: 'jruby', engine_version: '1.7.8'

gem 'rails', '4.0.1'
gem 'rake'

gem 'sepastian-mongoid-rails4', '~> 4.0.1.alpha'

gem 'rubyzip'
gem 'uuidtools'
gem 'jbuilder', '~> 1.2'
gem 'newrelic_rpm'
gem 'dalli'

group :production do
  gem 'rails_12factor', group: :production
  gem 'memcachier'
end

group :development, :test do
  gem 'semver'
  gem 'rspec-rails', '~> 3.0.0.beta'
  gem 'factory_girl_rails', '~> 4.3.0'
  gem 'metric_fu'
  gem 'database_cleaner'
end

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
gem 'capistrano', group: :development
gem 'capistrano-rails', group: :development
gem 'capistrano-ext', group: :development
gem 'capistrano-rbenv', github: 'capistrano/rbenv', group: :development
