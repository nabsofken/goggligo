class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|

      t.string  :title
      t.string  :placeholder
      t.integer :question_type
      t.string  :options, array: true, default: []
      t.boolean :required, default: false
      t.boolean :active, default: false

      t.timestamps null: false
    end
  end
end
