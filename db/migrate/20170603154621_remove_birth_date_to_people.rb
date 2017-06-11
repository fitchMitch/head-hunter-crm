class RemoveBirthDateToPeople < ActiveRecord::Migration[5.0]
  def change
    remove_column :people, :birthdate, :date
  end
end
