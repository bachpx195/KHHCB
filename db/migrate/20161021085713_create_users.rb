class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.references :group, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :avatar
      t.datetime :birthday
      t.string :phone
      t.string :address
      t.text :description
      t.string :website
      t.string :facebook
      t.string :organization
      t.integer :actived

      t.timestamps
    end
  end
end
