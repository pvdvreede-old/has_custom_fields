class TestItem < ActiveRecord::Base
  attr_accessible :a_field, :number_field

  has_custom_fields
end
