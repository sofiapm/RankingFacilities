class CreateFacilities < ActiveRecord::Migration
  def change
    create_table :facilities do |t|
      t.string :name, null: false
      t.string :sector, null: false

      t.timestamps
<<<<<<< HEAD
=======

      add_foreign_key(:users, :facilities, dependent: :delete) 
      add_foreign_key(:addresses, :facilities, dependent: :delete)  
>>>>>>> aa89705c01eb0f367142a46015abfef58d59100d
    end
  end
end
