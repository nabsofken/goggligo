class CreateUserIdentities < ActiveRecord::Migration
  def change
	create_table :user_identities do |t|
      t.string :device_id
      t.string :access_token
      t.references :user, index: true

      t.timestamps
    end

    add_index :user_identities, [:device_id, :user_id], unique: true unless index_exists?(:user_identities, [:device_id, :user_id])
    add_index :user_identities, :access_token, unique: true unless index_exists?(:user_identities, :access_token)
  end
end
