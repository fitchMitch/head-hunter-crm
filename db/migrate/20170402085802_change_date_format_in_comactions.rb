class ChangeDateFormatInComactions < ActiveRecord::Migration[5.0]
  def up
    change_column :comactions, :due_date, :datetime
  end

  def down
    change_column :comactions, :due_date, :date
  end
end
