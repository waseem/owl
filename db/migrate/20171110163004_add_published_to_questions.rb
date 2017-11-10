class AddPublishedToQuestions < ActiveRecord::Migration[5.1]
  def change
    add_column :questions, :published, :boolean, default: false
  end
end
