GtfsEngine.send_aliased_keys = true

GtfsEngine.sources do |s|
  s.halifax { url METRO_TRANSIT['zip_url'] }
end
