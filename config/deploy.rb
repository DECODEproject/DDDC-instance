# config valid for current version and patch releases of Capistrano
lock "~> 3.10.2"

set :application, "DDDC"
set :repo_url, "https://github.com/DECODEproject/DDDC-instance"

set :deploy_to, "/home/ruby-data/app"

set :rbenv_type, :user
set :delayed_job_workers, 1
set :rbenv_ruby, '2.5.1'

append :linked_files, "config/application.yml"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "public/assets", "public/uploads", "vendor/bundle"

set :puma_bind, "tcp://0.0.0.0:3001"
set :puma_user, fetch(:user)
append :rbenv_map_bins, 'puma', 'pumactl'
