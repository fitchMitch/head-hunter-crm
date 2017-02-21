class AddPersonRefToMissions < ActiveRecord::Migration[5.0]
  def change
    add_reference :missions, :person, foreign_key: true
  end
end
