class AddTemplateToQuestion < ActiveRecord::Migration
  def change
  	add_column :questions, :template, :boolean, default: false
  end
end
