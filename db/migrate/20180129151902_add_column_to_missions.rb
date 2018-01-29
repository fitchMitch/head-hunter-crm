class AddColumnToMissions < ActiveRecord::Migration[5.0]
  def change
    add_column :missions, :signed_at, :datetime
  end
end
