class AddViewedCountToCources < ActiveRecord::Migration[5.0]
  def change
    add_column :cources, :viewed_count, :integer
  end
end
