# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :calendar_exception do
    service_id "MyString"
    date "2014-03-08"
    exception_type 1
  end
end
