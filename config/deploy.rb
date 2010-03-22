#require 'deprec/recipes'

set :domain, "ticketapp.com"
role :web, domain
role :app, domain
role :db,  domain, :primary => true

set :application, "tickets"
set :deploy_to, "/var/www/apps/#{application}"

set :user, "andrew"

set :rails_env, "production"


# from http://www.zorched.net/2008/06/17/capistrano-deploy-with-git-and-passenger/
# and http://github.com/guides/deploying-with-capistrano

default_run_options[:pty] = true
set :scm, :git
set :repository, "git@github.com:andrew/ticketapp.git"
set :branch, "master"
set :deploy_via, :remote_cache

# set :user, 'andrew'
set :ssh_options, { :forward_agent => true } 
namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end