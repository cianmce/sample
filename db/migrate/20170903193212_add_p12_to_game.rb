class AddP12ToGame < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :p12, :text
  end
end
