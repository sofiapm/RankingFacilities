class CreateFacilityStaticMeasures < ActiveRecord::Migration
  def change
    create_table :facility_static_measures do |t|
      t.string :name
      t.float :value, :precision => 2
      t.date :start_date
      t.date :end_date
      t.integer :facility_id
      t.integer :user_id

      t.timestamps
    end
  end
end
