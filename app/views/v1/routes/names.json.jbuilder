json.array! @names do |name|
  json.shortName name.short_name
  json.longName name.long_name
end