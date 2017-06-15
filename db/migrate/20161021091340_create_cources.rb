class CreateCources < ActiveRecord::Migration[5.0]
  def change
    create_table :cources do |t|
      t.references :category, foreign_key: true
      t.references :user, foreign_key: true
      t.string :name
      t.references :province, foreign_key: true
      t.datetime :start_date
      t.string :schedule
      t.datetime :cource_date
      t.string :duration
      t.datetime :end_date
      t.string :address
      t.integer :cost
      t.string :cost_description
      t.string :promotion
      t.string :promotion_description
      t.string :image
      t.text :content
      t.string :representative
      t.string :email
      t.string :hotline
      t.string :organization_name
      t.string :organization_address
      t.string :organization_phone
      t.string :organization_email
      t.string :organization_website
      t.string :organization_facebook
      t.integer :status
      t.integer :featured
      t.integer :rate

      t.timestamps
    end
  end
end
