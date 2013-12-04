class AddAttachmentImageToUtopias < ActiveRecord::Migration
  def self.up
    change_table :utopias do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :utopias, :image
  end
end
