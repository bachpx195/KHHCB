class AddAttachmentImageToDashboards < ActiveRecord::Migration
  def self.up
    change_table :dashboards do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :dashboards, :image
  end
end
