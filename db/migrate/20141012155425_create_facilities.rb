class CreateFacilities < ActiveRecord::Migration
  def change
    create_table :facilities do |t|
      t.string :name, null: false
      t.integer :address_id, null: false
      t.integer :role_id, null: false
      t.integer :user_id, null: false

      t.timestamps

    end
  end
end
