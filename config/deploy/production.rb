server ENV['PRODUCTION_SERVER'], user: ENV['PRODUCTION_USER'], roles: %w{app}

set :ssh_options, {
  keys: ENV['PRODUCTION_KEYS'].split(','),
  forward_agent: true,
  compression: "none"
}
