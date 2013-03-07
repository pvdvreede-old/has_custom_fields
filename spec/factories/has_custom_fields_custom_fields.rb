# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence(:field_name) { |n| "field name #{n}" }

  factory :has_custom_fields_custom_field, :class => 'has_custom_fields/custom_field' do
    field_name
    field_type "string"
    belongs_to "TestItem"
  end
end
