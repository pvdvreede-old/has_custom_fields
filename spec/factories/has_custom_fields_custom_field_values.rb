# Read about factories at https://github.com/thoughtbot/factory_girl
require 'securerandom'

FactoryGirl.define do
  factory :has_custom_fields_custom_field_value, :class => 'has_custom_fields/custom_field_value' do
    custom_field_id 1
    field_value { SecureRandom.hex(13) }
    belongs_to_id 1
  end
end
