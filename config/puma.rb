# Puma can serve each request in a thread from an internal thread pool
# The `threads` method setting takes two numbers: a minimum and maximum
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. The default is set to 5 threads for minimum
# and maximum; this matches the default thread size of Active Record
#
threads_count = ENV.fetch("MAX_THREADS") { 5 }
threads threads_count, threads_count

# Specifies the `environment` that Puma will run in.
# Defaults to development
sinatra_env = ENV.fetch("SINATRA_ENV") { "development" }
environment sinatra_env

app_dir = File.expand_path("..", __FILE__)
if %w[production staging].member?(sinatra_env)
  app_dir = File.expand_path("../..", __FILE__)
end

directory app_dir
rackup "#{app_dir}/config.ru"

shared_tmp_dir = "#{app_dir}/tmp"

if %w[production staging].member?(sinatra_env)
  # Logging
  stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true

  # Set master PID and state locations
  pidfile "#{shared_tmp_dir}/pids/puma.pid"
  state_path "#{shared_tmp_dir}/pids/puma.state"

  # Change to match your CPU core count
  workers ENV.fetch("WEB_CONCURRENCY") { 2 }

  # Set up socket location
  bind "unix://#{shared_tmp_dir}/sockets/puma.sock"

  before_fork do
    ActiveRecord::Base.connection_pool.disconnect! if defined?(ActiveRecord)
  end

  on_worker_boot do
    ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
  end

elsif sinatra_env == "development"
  # Specifies the `port` that Puma will listen on to receive requests; default is 9292.
  port ENV.fetch("PORT") { 9292 }
  plugin :tmp_restart
end
