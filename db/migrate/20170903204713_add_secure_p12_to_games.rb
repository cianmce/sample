class AddSecureP12ToGames < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :encrypted_secure_p12, :text
    add_column :games, :encrypted_secure_p12_iv, :text
  end
end
