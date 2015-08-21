require "bundler/capistrano"

set :application, "sample app"
set :scm, :git
set :repository,  "git@github.com:pouria-hackernest/sample-app.git"
set :scm_passphrase, ""
set :deploy_to, "/root/deploy"

set :scm_username , "pouria-hackernest"
set :branch, fetch(:branch, "master")

set :normalize_asset_timestamps, false
#set :passenger_roles, :app
set :user, "root"

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "192.168.1.103"                          # Your HTTP server, Apache/etc
role :app, "192.168.1.103"                          # This may be the same as your `Web` server
role :db,  "192.168.1.103", :primary => true # This is where Rails migrations will run
role :db,  "192.168.1.103"

set :mysql_params, "-u root -ppassword"
set :mysql_db_name, "sample-app_development"

after :deploy, :migrate
desc "migrate database on server"
task :migrate do
  run "touch #{shared_path}/migration.list ;
ls -1v #{current_path}/sql/*.sql 2>/dev/null > #{shared_path}/migration.available;
diff #{shared_path}/migration.available #{shared_path}/migration.list | awk \"/^</ {print \\$2}\" | while read f ;
do echo \"migrating $(basename $f)\"; mysql #{mysql_params} #{mysql_db_name} < $f && echo $f >> #{shared_path}/migration.list ; done;
rm -f #{shared_path}/migration.available"
end

after "deploy:setup", :create_db
desc "create database on server"
task :create_db do
  run "mysql #{mysql_params} -e \"CREATE DATABASE #{mysql_db_name}\""
end


#set :stages, ["staging", "production"]
#set :default_stage, "production"

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"
#after 'deploy:update_code', 'deploy:migrate'

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
