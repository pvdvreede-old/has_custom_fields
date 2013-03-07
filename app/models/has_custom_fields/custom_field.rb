module HasCustomFields
  class CustomField < ActiveRecord::Base
    attr_accessible :belongs_to, :belongs_to_id, :field_type, :field_name
  end
end
