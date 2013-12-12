FactoryGirl.define do
  factory :user_group do
    ignore { count 0 }

    after(:build) do |user_group, evaluator|
      user_group.users = create_list :user_with_locations, evaluator.count
    end
  end
end
