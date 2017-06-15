class CreateBanners < ActiveRecord::Migration[5.0]
  def change
    create_table :banners do |t|
      t.string :name
      t.string :image
      t.string :url
      t.integer :position
      t.integer :status

      t.timestamps
    end
  end
end

