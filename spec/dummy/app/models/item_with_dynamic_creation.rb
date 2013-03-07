class ItemWithDynamicCreation < ActiveRecord::Base
  attr_accessible :a_field, :number_field

  has_custom_fields :allow_dynamic_creation => true
end
