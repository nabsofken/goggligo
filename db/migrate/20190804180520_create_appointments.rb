class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|

      t.string :email,              null: false, default: ""
      t.string :first_name,         null: false, default: ""
      t.string :last_name,          null: false, default: ""
      t.string :mobile_number
      t.string :reason_of_visit
      t.date :date_of_visit

      t.timestamps null: false
    end
  end
end
