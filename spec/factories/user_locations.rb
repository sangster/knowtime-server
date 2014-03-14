# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_location do
    user_id 1
    lat 1.5
    lon 1.5
    created_at "2014-03-12 00:36:25"
  end
end
