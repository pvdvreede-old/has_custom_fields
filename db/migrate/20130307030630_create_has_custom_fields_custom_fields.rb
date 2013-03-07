class CreateHasCustomFieldsCustomFields < ActiveRecord::Migration
  def change
    create_table :has_custom_fields_custom_fields do |t|
      t.string :field_name
      t.string :field_type
      t.string :belongs_to
      t.integer :belongs_to_id

      t.timestamps
    end
  end
end
