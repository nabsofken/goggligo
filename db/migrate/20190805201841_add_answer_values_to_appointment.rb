class AddAnswerValuesToAppointment < ActiveRecord::Migration
  def change
  	add_column :appointments, :answer_values, :string, default: {}
  end
end
