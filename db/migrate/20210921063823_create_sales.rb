class CreateSales < ActiveRecord::Migration[5.2]
  def change
    create_table :sales do |t|
      t.datetime :saleTime

      t.timestamps
    end
  end
end
