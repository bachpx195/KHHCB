class CreateCourceTags < ActiveRecord::Migration[5.0]
  def change
    create_table :cource_tags do |t|
      t.references :cource, foreign_key: true
      t.references :tag, foreign_key: true

      t.timestamps
    end
  end
end
