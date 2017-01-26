class CreateJobs < ActiveRecord::Migration[5.0]
  def change
    create_table :jobs do |t|

      t.string :job_title
      t.float :salary
      t.date :start_date
      t.date :end_date
      t.boolean :jj_job

      t.timestamps
    end
  end
end
