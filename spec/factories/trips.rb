# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :trip do
    sequence(:id) {|n| "trip-test-id-#{n}"}
    headsign 'test trip headsign'
    association :calendar, factory: :calendar
    association :path, factory: :path_with_points
    route
  end
end
