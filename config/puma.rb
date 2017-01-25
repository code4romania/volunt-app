threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }.to_i
threads threads_count, threads_count

app_dir = File.expand_path("../..", __FILE__)
tmp_dir = "#{app_dir}/tmp"

# Environment in which Puma runs
rails_env = ENV.fetch("RAILS_ENV") { "development" }
environment rails_env

# Listen on
bind "tcp://0.0.0.0:3000"

# Logging
stdout_redirect "#{tmp_dir}/log/puma.stdout.log", "#{tmp_dir}/log/puma.stderr.log", true

# Set master PID and state locations
pidfile "#{tmp_dir}/pids/puma.pid"
state_path "#{tmp_dir}/pids/puma.state"
activate_control_app

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart
