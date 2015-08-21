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
#role :db,  "192.168.1.103"

default_run_options[:pty] = true

set :local_database, "sample-app_development"
set :local_database_user, "root"
set :local_database_password, "password"
set :remote_database, "sample-app_development"
set :remote_database_user, "root"
set :remote_database_password, "password"
 
after "deploy:finalize_update", :update_database
 
desc "Upload the database to the server"
task :update_database, :roles => :db, :only => { :primary => true } do
    filename = "dump.#{Time.now.strftime '%Y%m%dT%H%M%S'}.sql"
    remote_path = "tmp/#{filename}"
    on_rollback {
        delete remote_path
    }
    dumped_sql = `mysqldump --user=#{local_database_user} --password=#{local_database_password} #{local_database}`
    put dumped_sql, remote_path
    run "mysql --user=#{remote_database_user} --password=#{remote_database_password} #{remote_database} < #{remote_path}"
end


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
