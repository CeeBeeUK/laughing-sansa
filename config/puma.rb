# Change to match your CPU core count
workers 4

# Min and Max threads per worker
threads 1, 6

app_dir = File.expand_path("../..", __FILE__)
shared_dir = "#{app_dir}/shared"

# Default to production
rails_env = ENV['RAILS_ENV'] || "development"
environment rails_env

if rails_env.eql?('production')
  # Set up socket location
  bind "unix://#{shared_dir}/sockets/puma.sock"
else
  port ENV.fetch("PORT", 3000)
end

activate_control_app

on_worker_boot do
  require "active_record"
  ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
  ActiveRecord::Base.establish_connection(YAML.load_file("#{app_dir}/config/database.yml")[rails_env])
end
