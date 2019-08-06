class AddFieldsToUser < ActiveRecord::Migration
  def change
  	add_column :users, :business_name, :string, default: ''
  	add_column :users, :address, :string, default: ''
  	add_column :users, :phone, :string, default: ''
  	add_column :users, :fax, :string, default: ''
  	add_column :users, :website, :string, default: ''
  	add_column :users, :contact_person_email, :string, default: ''
  	add_column :users, :contact_person_number, :string, default: ''
  end
end
