require 'bundler/capistrano'

set :user, 'your-username'
set :domain, 'your-domain'
set :application, 'nesta'
set :dir, 'your-applications-directory'

# the rest should be good
set :repository,  "git@your.git.server:path/to/your/git/repository" 
set :deploy_to, "/home/#{user}/#{dir}/#{application}"
set :deploy_via, :remote_cache
set :scm, 'git'
set :branch, 'master'
set :git_shallow_clone, 1
set :scm_verbose, true
set :use_sudo, false

default_run_options[:pty] = true
server domain, :app, :web

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end