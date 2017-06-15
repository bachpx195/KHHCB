class CreateUserAdits < ActiveRecord::Migration[5.0]
  def change
    create_table :user_adits do |t|
      t.references :user
      t.references :cource
      t.integer :action_type

      t.timestamps
    end
  end
end
