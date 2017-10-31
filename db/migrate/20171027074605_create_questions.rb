class CreateQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :questions do |t|
      t.string     :body,     null: false
      t.belongs_to :product,  null: false, foreign_key: true
      t.belongs_to :shop,     null: false, foreign_key: true
      t.belongs_to :asker,    null: false, foreign_key: { to_table: :customers }

      t.timestamps
    end
  end
end
