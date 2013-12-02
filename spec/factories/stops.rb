# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
	factory :stop do
		sequence :id
		name 'flamingo Dr before Meadowlark Cr'
		lat 44.669369
		lng -63.655807

		trait :from_csv do
			initialize_with do
				Stop.new Stop.new_from_csv(
					stop_id: id,
					stop_name: name,
					stop_lat: lat,
					stop_lon: lng)
			end
		end
	end
end
