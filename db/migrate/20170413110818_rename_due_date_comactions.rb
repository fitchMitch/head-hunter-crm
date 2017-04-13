class RenameDueDateComactions < ActiveRecord::Migration[5.0]

  def change
    add_column :comactions, :end_date, :datetime
    rename_column :comactions, :due_date , :start_date
  end
end
