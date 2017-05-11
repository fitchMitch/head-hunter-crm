class RenameDueDateBisComactions < ActiveRecord::Migration[5.0]
  def change
    rename_column :comactions, :start_date, :start_time
    rename_column :comactions, :end_date, :end_time
  end
end
