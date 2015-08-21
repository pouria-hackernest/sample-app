require "bundler/capistrano"
require 'capistrano-db-tasks'

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

#set :rails_env, "development"
set :db_local_clean, true
set :db_remote_clean, true

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "192.168.1.103"                          # Your HTTP server, Apache/etc
role :app, "192.168.1.103"                          # This may be the same as your `Web` server
role :db,  "192.168.1.103", :primary => true # This is where Rails migrations will run
#role :db,  "192.168.1.103"

#set :db_database, "sample-app_development"
#set :db_username, "root"
#set :db_password, "password"


#namespace(:deploy) do
#  desc "Backup MySQL Database"
#  task :mysqlbackup, :roles => :app do
#    run "mysqldump -u#{db_username} -p#{db_password} #{db_database} > #{shared_path}/backups/#{release_name}.sql"
#  end
#end

#namespace(:deploy) do
#  desc "Restore MySQL Database"
#  task :mysqlrestore, :roles => :app do
#    backups = capture("ls -1 #{shared_path}/backups/").split("\n")
#    default_backup = backups.last
#    puts "Available backups: "
#    puts backups
#    backup = Capistrano::CLI.ui.ask "Which backup would you like to restore? [#{default_backup}] "
#    backup_file = default_backup if backup.empty?

#    run "mysql -u#{db_username} -p#{db_password} #{db_database} < #{shared_path}/backups/#{backup_file}"
#  end
#end

#set :stages, ["staging", "production"]
#set :default_stage, "production"

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"
#after 'deploy:bundle_install', 'deploy:migrate'

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
