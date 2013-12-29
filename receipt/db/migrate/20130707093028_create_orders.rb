class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.decimal :tax_total, :default => 0
      t.decimal :item_total, :default => 0

      t.decimal :sales_tax_rate, :default => 0.1
      t.decimal :import_tax_rate, :default => 0.05

      t.timestamps
    end
  end
end
