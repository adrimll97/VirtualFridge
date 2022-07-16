# config valid for current version and patch releases of Capistrano
lock "~> 3.17.0"

require 'capistrano-db-tasks'

set :application, 'VirtualFridge'
set :repo_url, 'git@github.com:adrimll97/VirtualFridge.git'
set :branch, ENV['BRANCH'] if ENV['BRANCH']
set :deploy_to, '/home/deploy/VirtualFridge'
set :keep_releases, 5
set :rvm_custom_path, '/usr/share/rvm'
set :rvm_ruby_version, 'ruby-3.0.0'
set :pty, true

set :linked_files, %w[config/database.yml config/master.key]
set :linked_dirs, %w[log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system .bundle]

set :bundle_flags, ''

set :db_local_clean, true
set :db_remote_clean, true

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
end
