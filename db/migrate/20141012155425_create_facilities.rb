class CreateFacilities < ActiveRecord::Migration
  def change
    create_table :facilities do |t|
      t.string :name, null: false
      t.string :sector, null: false

      t.timestamps

      add_foreign_key(:users, :facilities, dependent: :delete) 
      add_foreign_key(:addresses, :facilities, dependent: :delete)  
    end
  end
end
