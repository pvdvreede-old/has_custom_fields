
FactoryGirl.define do
  factory :test_item do
    a_field "string"
    number_field { rand(1..1234) }
  end
end