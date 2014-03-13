FactoryGirl.define do
  factory :calendar do
    sequence(:service_id) {|n| "test-calendar-id-#{n}"}
    start_date DateTime.parse '2014-01-01'
    end_date DateTime.parse '2015-01-01'
    monday true
    tuesday true
    wednesday true
    thursday true
    friday true
    saturday false
    sunday false

    factory :calendar_for_saturday do
      monday false
      tuesday false
      wednesday false
      thursday false
      friday false
      saturday true
    end
    
    factory :calendar_for_sunday do
      monday false
      tuesday false
      wednesday false
      thursday false
      friday false
      sunday true
    end
  end
end
