FactoryGirl.define do
  factory :route do
    sequence(:route_id) {|n| "1-#{n * 100}"}
    route_short_name '999'
    route_long_name 'Test Route'
  end
end
