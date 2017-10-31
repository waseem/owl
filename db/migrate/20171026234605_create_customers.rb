class CreateCustomers < ActiveRecord::Migration[5.1]
  def change
    create_table :customers do |t|
      t.bigint     :shopify_id
      t.string     :email
      t.string     :name
      t.belongs_to :shop, null: false, foreign_key: true

      t.timestamps
    end

    add_index :customers, :shopify_id
    add_index :customers, :email
  end
end
