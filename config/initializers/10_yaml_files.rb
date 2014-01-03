METRO_TRANSIT = YAML.load_file("#{::Rails.root}/config/metro_transit.yml")[::Rails.env]

if ::Rails.env == 'production'
  SECRETS = YAML.load_file("/etc/knowtime_secrets.yml")
else
  SECRETS = YAML.load_file("#{::Rails.root}/config/development_secrets.yml")
end
