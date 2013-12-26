class AddAttachmentAvatarToHikers < ActiveRecord::Migration
  def self.up
    change_table :hikers do |t|
      t.attachment :avatar
    end
  end

  def self.down
    drop_attached_file :hikers, :avatar
  end
end
