source 'https://rubygems.org'

ruby '2.1.2'

gem 'gtfs-engine'

gem 'rails', '~> 4.1'
gem 'rake', '~> 10.3'
gem 'pg', '~> 0.17'
gem 'activerecord-import', '~> 0.5'
gem 'yajl-ruby'

gem 'rubyzip', '~> 1.1'
gem 'uuidtools', '~> 2.1'
gem 'jbuilder', '~> 2.1'
gem 'haml-rails', '~> 0.5'
gem 'dalli', '~> 2.7'
gem 'rest-client', '~> 1.7'

group :production do
  gem 'rails_12factor'
  gem 'memcachier'
  gem 'unicorn', '~> 4.8'
  gem 'newrelic_rpm', '~> 3.9'
end

group :development, :test do
  gem 'better_errors', '~> 1.0'
  gem 'pry-rails', '~> 0.3'
  gem 'semver', '~> 1.0'
  gem 'rspec-rails', '~> 3.0'
  gem 'factory_girl_rails', '~> 4.4'
  gem 'metric_fu', '~> 4.11'
  gem 'database_cleaner', '~> 1.3'
end
