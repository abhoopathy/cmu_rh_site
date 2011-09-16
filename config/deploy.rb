require 'bundler/capistrano'

set :use_sudo, false
set :group_writable, false

set :user, 'aneesbc'
set :domain, 'aneeshbc@aneeshb.com'
set :application, 'cmurh'
set :dir, 'public_html'

# trying
default_run_options[:pty] = true

# the rest should be good
set :repository, 'git@github.com:abhoopathy/cmu_rh_site.git' 
set :deploy_to, "#{dir}/cmurh.aneeshb.com"
set :deploy_via, :remote_cache
set :scm, 'git'
set :branch, 'master'
set :git_shallow_clone, 1
set :scm_verbose, true
set :use_sudo, false
set :scm_passphrase, "umgoblue"

default_run_options[:pty] = true
server domain, :app, :web

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
