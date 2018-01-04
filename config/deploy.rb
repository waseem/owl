# config valid for current version and patch releases of Capistrano
lock "~> 3.10.1"

set :application, "owl"
set :repo_url, "git@bitbucket.org:waseem_/owl.git"
set :chruby_ruby, 'ruby-2.5.0'
set :use_sudo, false

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deploy/deploys/owl"

# Fetch only the changes from git repo since last deploy
set :deploy_via, :remote_cache

# Defaults to false
# Skip migration if files in db/migrate were not modified
# set :conditionally_migrate, true

# Defaults to nil (no asset cleaup is performed)
# If you use Rails 4+ and you'd like to clean up old assets after each deploy,
# set this to the number of versions to keep
set :keep_assets, 5


# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/secrets.yml", "log/nginx.access.log", "log/nginx.error.log", ".env"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "vendor/bundle", "tmp/sockets", "public/system"

# Set the migration role to app so that we don't have to deploy our codebase to db server
set :migration_role, :app

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
#
after "deploy:finishing", "puma:restart"
