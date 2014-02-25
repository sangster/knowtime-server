json.array! @groups do |group|
  json.tripGroupId group.id
  json.trips group.trips.collect &:id
end
