FactoryGirl.define do
  factory :stop_time do
    ignore { stop_time_row strategy: :build }

    initialize_with do
      create :trip, id: stop_time_row[:trip_id]
      StopTime.new_from_csv(stop_time_row).first.tap { StopTime.skip_final_bulk_insert? }
    end
  end

  factory :stop_time_row, class: Hash do
    ignore do
      sequence(:trip_id) { |n| "trip_id_#{n}" }
      sequence(:stop_id, 1000) { |n| "#{n}" }
      sequence(:stop_sequence) { |n| "#{n}" }
      association :arrival_time, factory: :time_str, strategy: :build
      association :departure_time, factory: :time_str, strategy: :build
    end

    initialize_with do
      { trip_id: trip_id, stop_id: stop_id, stop_sequence: stop_sequence,
        arrival_time: arrival_time, departure_time: departure_time }
    end
  end

  factory :time_str, class: String do
    ignore { sequence :minutes }

    initialize_with { '%02d:%02d' % [minutes/60, minutes%60] }
  end
end
