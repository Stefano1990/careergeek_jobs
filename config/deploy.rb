require "bundler/capistrano"

server "5.9.96.107", :web, :app, :db, primary: true

set :application, "careergeek_jobs"
#set :repository,  "git@github.com:Stefano1990/#{application}.git"
set :repository,  "git://github.com/Stefano1990/careergeek_jobs.git/"
set :branch, "master"

set :scm, "git"
set :user, "deployer"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

default_run_options[:pty] = true
set :ssh_options, { forward_agent: true }

after "deploy", "deploy:cleanup"

namespace :deploy do

	task :setup_config, roles: :app do
		sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
		#sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
		run "mkdir -p #{shared_path}/config"
		put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
		puts "Now edit the config files in #{shared_path}."
	end
	after "deploy:setup", "deploy:setup_config"

	task :symlink_config, roles: :app do
		run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
	end
	after "deploy:finalize_update", "deploy:symlink_config"

	desc "Make sure local git is in sync with remote."
	task :check_revision, roles: :web do
		unless `git rev-parse HEAD` == `git rev-parse origin/master`
			puts "WARNING: HEAD is not the same as origin/master"
			puts "Run `git push` to sync changes."
			exit
		end
	end

	%w[start stop restart].each do |command|
		desc "#{command} thin server"
		task command, roles: :app, except: { no_release: true } do
			run <<-CMD
      cd /home/#{user}/apps/#{application}/current; bundle exec thin #{command} -C config/thin.yml
			CMD
		end
	end
	before "deploy", "deploy:check_revision"

	#desc "Set the carrierwave upload directory"
	#run <<-CMD
 	#	rm -rf #{latest_release}/public/uploads &&
  	#ln -s #{shared_path}/uploads #{latest_release}/public/uploads
	#CMD
end
#namespace :delayed_job do
#	desc "Restart the delayed_job process"
#	task :restart, :roles => :app do
#		run "cd #{current_path}; RAILS_ENV=#{rails_env} script/delayed_job restart"
#	end
#end
#after "deploy:update_code", "delayed_job:restart"
#
#set :private_pub_pid, "#{deploy_to}/shared/pids/private_pub.pid"
#set :private_pub_config, "#{deploy_to}/current/private_pub.ru"
#namespace :private_pub do
#	desc "Start private_pub"
#	task :start do
#		run "cd #{deploy_to}/current && rbenv exec bundle exec rackup #{private_pub_config} -s thin -E production -D --pid #{private_pub_pid}"
#	end
#	desc "Stop private_pub"
#	task :stop do
#		run "kill `cat #{private_pub_pid}` || true"
#	end
#end
#before 'deploy:update_code', 'private_pub:stop'
#after 'deploy:finalize_update', 'private_pub:start'