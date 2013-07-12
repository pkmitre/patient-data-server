require "bundler/capistrano"

set :bundle_without, [:test, :development]

load 'deploy/assets'

set :scm, :git
set :repository, "https://github.com/ssayer/patient-data-server.git"
set :branch, "develop"

set :user, "ubuntu"
ssh_options[:keys] = [File.join(__FILE__, "..", "..", "gganleykey.pem")]
puts ssh_options[:keys]

set :application, "pds"

role :web, 'pds.csis.tatrc-rhex.us', 'pds.usafa.tatrc-rhex.us'
role :app, 'pds.csis.tatrc-rhex.us', 'pds.usafa.tatrc-rhex.us'
role :db, 'pds.csis.tatrc-rhex.us', 'pds.usafa.tatrc-rhex.us'

default_run_options[:pty] = true
ssh_options[:paranoid] = true

set :deploy_to, "/var/www/rails_apps/pds"
set :deploy_via, :remote_cache
set :copy_exclude, [".git"]

namespace :deploy do

  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  after "deploy:finalize_update", "deploy:customize_deployment"

  task :customize_deployment do
    run <<-CMD
      rm -f #{release_path}/config/oauth2.yml &&
      ln -nfs #{shared_path}/config/oauth2.yml #{release_path}/config/oauth2.yml &&
      rm -f #{release_path}/config/ui.yml &&
      ln -nfs #{shared_path}/config/ui.yml #{release_path}/config/ui.yml &&
      rm -f #{release_path}/public/logo.png &&
      ln -nfs #{shared_path}/config/logo.png #{release_path}/public/logo.png
    CMD
  end

end
