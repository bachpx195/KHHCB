class CreateSlides < ActiveRecord::Migration[5.0]
  def change
    create_table :slides do |t|
      t.string :name
      t.string :image
      t.text :description
      t.string :url
      t.integer :status

      t.timestamps
    end
  end
end
