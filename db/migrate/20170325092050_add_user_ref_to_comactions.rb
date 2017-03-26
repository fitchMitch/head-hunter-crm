class AddUserRefToComactions < ActiveRecord::Migration[5.0]
  def change
    add_reference :comactions, :user, foreign_key: true
    add_reference :comactions, :mission, foreign_key: true
    add_reference :comactions, :person, foreign_key: true
  end
end
