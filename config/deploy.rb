lock "~> 3.18.0"

set :application,     'qna'
set :repo_url, "git@github.com:kaltag/Qna.git"

set :deploy_to,   "/home/deployer/qna"
set :deploy_user, 'deployer'
set :branch,          'main'
set :pty, false

append :linked_files, "config/database.yml", 'config/master.key'
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "vendor", "storage"
