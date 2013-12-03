# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :calendar do
    start_date DateTime.parse '2014-01-01'
    end_date DateTime.parse '2015-01-01'
    weekday true
    saturday false
    sunday false

    factory :calendar_for_saturday do
      weekday false
      saturday true
    end
    
    factory :calendar_for_sunday do
      weekday false
      sunday true
    end
  end
end
