GtfsEngine.config.sources do |s|
  s.halifax { url METRO_TRANSIT['zip_url'] }
end

puts GtfsEngine.config.sources.to_hash
