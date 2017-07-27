class RemoveAgesColumnToMissions < ActiveRecord::Migration[5.0]
  def change
    remove_column :missions, :min_age, :integer
    remove_column :missions, :max_age, :integer
  end
end
