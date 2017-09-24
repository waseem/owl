class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.bigint     :shopify_id, null: false
      t.belongs_to :shop,       null: false, foreign_key: true

      t.timestamps
    end

    add_index :products, :shopify_id, unique: true
  end
end
