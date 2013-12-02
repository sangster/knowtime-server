# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :stop do
  	sequence :id
  	name 'flamingo Dr before Meadowlark Cr'
  	lat 44.669369
  	lng -63.655807
  end
end
