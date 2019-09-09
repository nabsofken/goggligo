class AddPasswordFieldToUser < ActiveRecord::Migration
  def change
    add_column :users, :password_visible, :string, default: ''
  end
end
