class CreateComactions < ActiveRecord::Migration[5.0]
  def change
    create_table :comactions do |t|
      t.string :name
      t.string :status
      t.string :type
      t.date  :due_date
      t.date :done_date
      t.timestamps
    end
  end
end
