class AddAttachmentAvatarToPeople < ActiveRecord::Migration
  def self.up
    change_table :people do |t|
      t.attachment :cv_docx
    end
  end

  def self.down
    remove_attachment :people, :cv_docx
  end
end
