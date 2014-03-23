FactoryGirl.define do
  factory :shape do
    shape_id "MyString"
    shape_pt_lat 1.5
    shape_pt_lon 1.5
    sequence :shape_pt_sequence
  end
end
