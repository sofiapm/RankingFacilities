class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :location, null: false, unique: true
      t.string :city, null: false
      t.string :country, null: false
      t.integer :zip_code, null: false

      t.timestamps
    end
  end
end
