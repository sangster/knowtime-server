json.routeId @route.id
json.shortName @route.short_name
json.longName @route.long_name

json.trips @route.trips.collect &:id
