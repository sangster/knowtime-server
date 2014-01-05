require 'yaml'

METRO_TRANSIT = YAML.load_file("config/metro_transit.yml")[::Rails.env]

SECRETS = if ::Rails.env == 'production'
  { 'knowtime' => { 'admin_uuid' => ENV['knowtime-admin_uuid'] },
    'rails'    => { 'key_base'   => ENV['rails-key_base'] },
    'api_keys' => { 'new_relic'  => ENV['api_keys-new_relic'] } }
else
  YAML.load_file('config/development_secrets.yml')
end
