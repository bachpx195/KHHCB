class AddAttachmentImageToCources < ActiveRecord::Migration
  def self.up
    change_table :cources do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :cources, :image
  end
end
