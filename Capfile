# Load DSL and set up stages
require "capistrano/setup"

# Include default deployment tasks
require "capistrano/deploy"

require "capistrano/rvm"
require "capistrano/bundler"
require "capistrano/rails"
# require "capistrano/passenger"
require 'capistrano3/unicorn'
require "capistrano/scm/git"
require 'capistrano/sidekiq'

require "whenever/capistrano"

install_plugin Capistrano::Sidekiq
install_plugin Capistrano::Sidekiq::Systemd
install_plugin Capistrano::SCM::Git


# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
