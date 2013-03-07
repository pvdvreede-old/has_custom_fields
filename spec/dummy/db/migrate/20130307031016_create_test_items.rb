class CreateTestItems < ActiveRecord::Migration
  def change
    create_table :test_items do |t|
      t.string :a_field
      t.integer :number_field

      t.timestamps
    end
  end
end
