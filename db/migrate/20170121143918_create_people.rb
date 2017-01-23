class CreatePeople < ActiveRecord::Migration[5.0]
  def change
    create_table :people do |t|
      t.string :title
      t.string :firstname
      t.string :lastname
      t.string :email
      t.string :phone_number
      t.string :cell_phone_number
      t.date :birthdate

      t.timestamps
    end
    add_index :people, :email
  end
end
