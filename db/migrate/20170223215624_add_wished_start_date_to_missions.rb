class AddWishedStartDateToMissions < ActiveRecord::Migration[5.0]
  def change
    add_column :missions, :whished_start_date, :date
  end
end
