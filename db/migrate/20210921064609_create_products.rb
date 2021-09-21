class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :stock
      t.integer :price
      t.boolean :active

      t.timestamps
    end
  end
end
