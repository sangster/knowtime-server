require 'uuidtools'

FactoryGirl.define do
  factory :user do
    sequence(:short_name) {|n| "#{n}"}
    uuid { BSON::Binary.new UUIDTools::UUID.random_create.raw, :uuid }

    ignore do
      lat nil
      lng nil
    end

    after(:create) do |user, evaluator|
      lat = evaluator.lat
      lng = evaluator.lng
      user.user_locations.create! lat: lat, lng: lng if lat and lng
    end

    factory :user_with_locations do
      ignore { locations 10 }

      after(:create) do |user, evaluator|
        create_list :user_location, evaluator.locations, user: user
      end
    end
  end

  #factory :user_location do
  #  created_at { DateTime.now }
  #  sequence(:lat) {|n| 10.0000123456 + (n/10000.0) }
  #  sequence(:lng) {|n| 20.0000123456 + (n/10000.0) }
  #
  #  trait :old do
  #    created_at { DateTime.now - 1.week }
  #  end
  #end
end
