require 'bundler/capistrano'
set :application, "scc"
set :deploy_to, "/var/www/#{application}"
set :user, 'root'
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :scm_username, "slavam"
set :repository,  "git://github.com/slavam/utilities.git"

role :web, "10.40.28.10"                          # Your HTTP server, Apache/etc
role :app, "10.40.28.10"                          # This may be the same as your `Web` server
role :db,  "10.40.28.10", :primary => true # This is where Rails migrations will run

# If you are using Passenger mod_rails uncomment this:

namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  task :restart do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end