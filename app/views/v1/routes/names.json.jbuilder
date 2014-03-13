names = @routes.collect {|r| {short_name: r.short_name,
                              long_name: r.long_name} }
json.array! names.uniq do |name|
  json.shortName name[:short_name]
  json.longName name[:long_name]
end