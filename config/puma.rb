threads_count = ENV.fetch("MAX_THREADS") { 5 }
threads threads_count, threads_count

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
  stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true

  pidfile "#{shared_tmp_dir}/pids/puma.pid"
  state_path "#{shared_tmp_dir}/pids/puma.state"

  # Change to match your CPU core count
  workers ENV.fetch("WEB_CONCURRENCY") { 2 }

  bind "unix://#{shared_tmp_dir}/sockets/puma.sock"

  before_fork do
    ActiveRecord::Base.connection_pool.disconnect! if defined?(ActiveRecord)
  end

  on_worker_boot do
    ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
  end

elsif sinatra_env == "development"
  port ENV.fetch("PORT") { 9393 }
  plugin :tmp_restart
end
