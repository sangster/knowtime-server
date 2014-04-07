GtfsEngine.send_aliased_keys = true

GtfsEngine.sources do |s|
  s.halifax { url METRO_TRANSIT['zip_url'] }
  s.sample  { url 'http://localhost/sample-feed.zip' }
end
