class AddFacilityIdToIndicators < ActiveRecord::Migration
  def change
    add_column :indicators, :facility_id, :integer
  end
end
