class AddQuestionKeyToQuestion < ActiveRecord::Migration
  def change
  	add_column :questions, :question_key, :string, default: ''
  end
end
