class RemoveColumnToComactions < ActiveRecord::Migration[5.0]
  def change
    remove_column :comactions, :done_date, :date
  end
end
