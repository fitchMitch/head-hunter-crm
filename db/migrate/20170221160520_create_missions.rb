class CreateMissions < ActiveRecord::Migration[5.0]
  def change
    create_table :missions do |t|
      t.string :name
      t.float :reward
      t.float :paid_amount
      t.float :min_salary
      t.float :max_salary
      t.string :criteria
      t.integer :min_age
      t.integer :max_age
      t.boolean :signed
      t.boolean :is_done

      t.timestamps
    end
  end
end
