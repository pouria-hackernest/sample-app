#server "192.168.1.103", :app, :web, :db, :primary => true
set :deploy_to, "/root/deploy"


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


