# Change to match your CPU core count
workers 4

# Min and Max threads per worker
threads 1, 6

app_dir = File.expand_path("../..", __FILE__)
shared_dir = "#{app_dir}/shared"

# Default to production
rails_env = ENV['RAILS_ENV'] || "development"
environment rails_env

#if rails_env.eql?('production')
#  # Set up socket location
#  bind "unix://#{shared_dir}/sockets/puma.sock"
#else
#  port ENV.fetch("PORT", 3000)
#end

port ENV.fetch("PORT", 3000)

activate_control_app

