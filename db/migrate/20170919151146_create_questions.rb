class CreateQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :questions do |t|
      t.string     :body,     null: false
      t.belongs_to :product,  null: false, foreign_key: true

      t.timestamps
    end
  end
end
