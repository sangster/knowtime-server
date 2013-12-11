require 'uuidtools'

FactoryGirl.define do
  factory :user do
    sequence(:short_name) {|n| "#{n}"}
    uuid { BSON::Binary.new UUIDTools::UUID.random_create.raw, :uuid }

    factory :user_with_locations do
      ignore { locations 10 }

      after(:create) do |user, evaluator|
        create_list :user_location, evaluator.locations, user: user
      end
    end
  end

  factory :user_location do
    created_at { DateTime.now }
    sequence(:lat) {|n| 10.0000123456 + (n/10.0) }
    sequence(:lng) {|n| 200.0000123456 + (n/10.0) }
  end
end
