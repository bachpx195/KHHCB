class CreateDashboards < ActiveRecord::Migration[5.0]
  def change
    create_table :dashboards do |t|
      t.string :col1
      t.string :col2
      t.string :col3

      t.timestamps
    end
  end
end
