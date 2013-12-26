class AddAttachmentPictureToDinners < ActiveRecord::Migration
  def self.up
    change_table :dinners do |t|
      t.attachment :picture
    end
  end

  def self.down
    drop_attached_file :dinners, :picture
  end
end
