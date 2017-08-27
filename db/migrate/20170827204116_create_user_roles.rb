class CreateUserRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :user_roles do |t|
      t.references :user, foreign_key: true
      t.references :role, foreign_key: true
      t.references :game, foreign_key: true
      t.index [:role_id, :role_id, :game_id], unique: true

      t.timestamps
    end
  end
end
