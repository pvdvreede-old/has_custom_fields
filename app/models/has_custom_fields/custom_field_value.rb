module HasCustomFields
  class CustomFieldValue < ActiveRecord::Base
    attr_accessible :belongs_to_id, :custom_field_id, :field_value

    belongs_to :custom_field
  end
end
