require 'ostruct'

FactoryGirl.define do
	factory :stop do
		sequence :id
		name 'flamingo Dr before Meadowlark Cr'
		lat 44.669369
		lng -63.655807

		trait :from_csv do
			initialize_with do
				Stop.from_gtfs OpenStruct.new id: "#{id}",
				  name: name,
				  lat: lat,
				  lon: lng
			end
		end
	end
end
