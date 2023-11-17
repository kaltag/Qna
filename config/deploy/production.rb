server '79.174.94.218', user: "deployer", port: 2222, roles: [:web, :app, :db], primary: true

set :ssh_options, {
  keys: %w(/home/kaltag/.ssh/id_rsa),
  forward_agent: true,
  auth_methods: %w(publickey password)
}
