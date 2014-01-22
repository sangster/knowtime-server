FactoryGirl.define do
  factory :route do
    sequence(:id) {|n| "1-#{n * 100}"}
    short_name '999'
    long_name 'Test Route'
  end
end
