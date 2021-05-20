ENV["SINATRA_ENV"] ||= "development"

require_relative './config/environment'
require 'sinatra/activerecord/rake'

use Rack::MethodOverride
use Rack::JSONBodyParser

desc "Launc Console"
task :console do
  Pry.start
end

namespace :example do
  task :script do
    system("bundle exec ruby #{File.dirname(__FILE__)}/bin/example_script.rb")
    puts "Example script is complete!"
  end
end
