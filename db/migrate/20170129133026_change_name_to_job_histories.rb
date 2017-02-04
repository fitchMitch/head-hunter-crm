class ChangeNameToJobHistories < ActiveRecord::Migration[5.0]
    def change
        remove_index :job_histories, :job_history_id
        rename_column :job_histories, :job_history_id, :job_id
    end
end
