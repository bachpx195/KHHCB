class CreateNews < ActiveRecord::Migration[5.0]
  def change
    create_table :news do |t|
      t.references :category_news, foreign_key: true
      t.string :title
      # t.string :image
      t.text :description
      t.text :content

      t.timestamps
    end
  end
end
