class CreateJobHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :job_histories do |t|
      t.belongs_to :job_history, index:true
      t.belongs_to :person, index:true
      t.timestamps
    end
  end
end
