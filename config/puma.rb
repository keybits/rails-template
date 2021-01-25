threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count

port ENV.fetch("PORT") { 3000 }

rails_env = ENV.fetch("RAILS_ENV") { "development" }
environment rails_env

if %w[production staging].member?(rails_env)
    app_dir = ENV.fetch("APP_DIR") { "YOUR_APP/current" }
    directory app_dir

    shared_dir = ENV.fetch("SHARED_DIR") { "YOUR_APP/shared" }

    # Logging
    stdout_redirect "#{shared_dir}/log/puma.stdout.log", "#{shared_dir}/log/puma.stderr.log", true
    
    pidfile "#{shared_dir}/tmp/pids/puma.pid"
    state_path "#{shared_dir}/tmp/pids/puma.state"
    
    # Set up socket location
    bind "unix://#{shared_dir}/sockets/puma.sock"
    
    workers ENV.fetch("WEB_CONCURRENCY") { 2 }
    preload_app!

elsif rails_env == "development"
    plugin :tmp_restart
end
