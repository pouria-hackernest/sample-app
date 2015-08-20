require "bundler/capistrano"

set :application, "sample app"
set :scm, :git
set :repository,  "git@github.com:pouria-hackernest/sample-app.git"
set :scm_passphrase, ""
set :deploy_to, "/root/deploy"

set :scm_username , "pouria-hackernest"
set :branch, fetch(:branch, "master")

set :normalize_asset_timestamps, false

set :user, "root"

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "192.168.1.103"                          # Your HTTP server, Apache/etc
role :app, "192.168.1.103"                          # This may be the same as your `Web` server
role :db,  "192.168.1.103", :primary => true # This is where Rails migrations will run
role :db,  "192.168.1.103"

#set :stages, ["staging", "production"]
#set :default_stage, "production"

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"
after 'deploy:update_code', 'deploy:migrate'

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
