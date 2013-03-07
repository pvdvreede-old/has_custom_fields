class CreateHasCustomFieldsCustomFieldValues < ActiveRecord::Migration
  def change
    create_table :has_custom_fields_custom_field_values do |t|
      t.integer :custom_field_id
      t.text :field_value
      t.integer :belongs_to_id

      t.timestamps
    end
  end
end
