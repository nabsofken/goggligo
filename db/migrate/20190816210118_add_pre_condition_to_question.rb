class AddPreConditionToQuestion < ActiveRecord::Migration
  def change
  	add_column :questions, :pre_condition_question_id, :integer
  	add_column :questions, :pre_condition_question_value, :string, default: ''
  end
end
