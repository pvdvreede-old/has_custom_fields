class CreateItemWithDynamicCreations < ActiveRecord::Migration
  def change
    create_table :item_with_dynamic_creations do |t|
      t.string :a_field
      t.integer :number_field

      t.timestamps
    end
  end
end
