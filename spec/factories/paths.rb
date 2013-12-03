FactoryGirl.define do
  factory :path do
    sequence(:id) { |n| "factory_path_id_#{n}"}

    factory :path_with_points do
      ignore { points 10 }

      after(:create) do |path, evaluator|
        create_list :path_point, evaluator.points, path: path
      end
    end
  end

  factory :path_point do
    sequence(:index)
    sequence(:lat) {|n| 10.0000123456 + (n/10.0) }
    sequence(:lng) {|n| 200.0000123456 + (n/10.0) }
  end
end
