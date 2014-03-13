namespace :knowtime do
  desc 'Convert users collection to JSON'
  task users_json: :environment do
    hash =
      User.all.collect do |user|
        locations = user.user_locations.collect do |loc|
          { lat: loc.lat,
            lng: loc.lng,
            created_at: loc.created_at }
        end

        { uuid: user.uuid_str,
          short_name: user.short_name,
          locations: locations }
      end

    puts hash.to_json
  end
end
