# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'events-app'
set :repo_url, 'git@github.com:oki/events-app.git'

# Default deploy_to directory is /var/www/my_app
set :deploy_to, ENV['DEPLOY_TO']

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.1.2'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

set :bundle_bins, %w{gem rake rails foreman}

set :linked_files, %w{.env}

before "deploy:restart",  "foreman:export"

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      sudo "service events_app restart"
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end
