source 'http://rubygems.org'
ruby "3.0.1"

gem 'sinatra'
gem 'activerecord', '~> 6.0', '>= 6.0.3.2', :require => 'active_record'
gem 'sinatra-activerecord', :require => 'sinatra/activerecord'
gem 'rake'
gem 'require_all'
gem 'pg'
gem 'puma'
gem 'shotgun'
gem 'sinatra-jsonp'
gem "sinatra-cross_origin"
gem 'rack-contrib'
gem 'fast_jsonapi'
gem 'sinatra-contrib', require: false
gem 'pry'
gem 'tux'

group :development do
  gem 'capistrano', '~> 3.16', require: false
  gem 'capistrano3-puma', '~> 5.0.2', require: false
  gem 'capistrano-rvm', '~> 0.1.2', require: false
  gem 'capistrano-bundler', '~> 2.0.1', require: false
end

group :test do
  gem 'rspec'
  gem 'capybara'
  gem 'rack-test'
end
