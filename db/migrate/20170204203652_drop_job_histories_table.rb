class DropJobHistoriesTable < ActiveRecord::Migration[5.0]
  def change
    def up
      drop_table :job_histories
    end

    def down
      raise ActiveRecord::IrreversibleMigration
    end
  end
end
