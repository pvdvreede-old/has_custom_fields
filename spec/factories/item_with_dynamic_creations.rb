
FactoryGirl.define do
  factory :item_with_dynamic_creation do
    a_field "field"
    number_field { rand(1..4453453) }
  end
end