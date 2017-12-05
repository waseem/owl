class CreateAnswers < ActiveRecord::Migration[5.1]
  def change
    create_table :answers do |t|
      t.string     :body,      null: false
      t.belongs_to :question,  null: false, foreign_key: true
      t.belongs_to :shop,      null: false, foreign_key: true

      t.timestamps
    end
  end
end
