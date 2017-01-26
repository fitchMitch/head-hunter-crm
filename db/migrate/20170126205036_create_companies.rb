class CreateCompanies < ActiveRecord::Migration[5.0]
  def change
    create_table :companies do |t|
      t.string :company_name
      t.integer :job_id

      t.timestamps
    end
    add_index :companies, :job_id
  end
end
