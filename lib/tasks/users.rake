namespace :knowtime do
  desc 'Convert users collection to JSON'
  task users_json: :environment do

    first = true

    puts '['
    User.all.each do |user|
      locations =
        user.user_locations.collect do |loc|
          { lat: loc.lat,
            lng: loc.lng,
            created_at: loc.created_at }
        end

      json = {       uuid: user.uuid_str,
               short_name: user.short_name,
                locations: locations }.to_json
      if first
        first = false
      else
        puts ?,
      end
      puts json
    end
    puts ']'
  end
end
