class CreateMeasures < ActiveRecord::Migration
  def change
    create_table :measures do |t|
      t.string :name, null: false
      t.float :value, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.string :unit, null: false

      t.timestamps

      add_foreign_key(:facilities, :measures, dependent: :delete) 
    end
  end
end
