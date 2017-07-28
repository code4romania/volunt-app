threads_count = Integer(ENV['RAILS_MAX_THREADS'] || 5)
threads threads_count, threads_count

app_dir = File.expand_path("../..", __FILE__)
tmp_dir = "#{app_dir}/tmp"

# Environment in which Puma runs
rackup      DefaultRackup
port        ENV['PORT'] || 3000
environment ENV['RAILS_ENV'] || 'development'
daemonize false

# Logging
stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true

# Set master PID and state locations
pidfile "#{tmp_dir}/pids/puma.pid"
state_path "#{tmp_dir}/pids/puma.state"
activate_control_app

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart


# prune_bundler
