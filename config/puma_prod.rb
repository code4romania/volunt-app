threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }.to_i
threads threads_count, threads_count

app_dir = File.expand_path("../..", __FILE__)
tmp_dir = "#{app_dir}/tmp"

# Default to production
rails_env = ENV.fetch('RAILS_ENV') { "production" }
environment rails_env

# Listen on
bind "unix://#{tmp_dir}/puma/puma.sock"

# Logging
stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true

# Set master PID and state locations
pidfile "#{tmp_dir}/pids/puma.pid"
state_path "#{tmp_dir}/pids/puma.state"
activate_control_app

