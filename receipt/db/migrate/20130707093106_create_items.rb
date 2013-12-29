class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :description
      t.integer :quantity
      t.decimal :price, :default => 0

      t.boolean :is_exempt, :default => false
      t.boolean :is_import, :default => false

      t.timestamps
    end
  end
end
