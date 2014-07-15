GtfsEngine.send_aliased_keys = true

GtfsEngine.sources do |s|
  s.halifax do
    title 'Halifax Metro'
    url METRO_TRANSIT['zip_url']
  end
  s.edmonton do
    title "Edmonton Transit System"
    url 'http://webdocs.edmonton.ca/transit/etsdatafeed/google_transit.zip'
  end
  s.sample do
    title 'Google Sample Feed'
    url 'http://localhost/sample-feed.zip'
  end
end
