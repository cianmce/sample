class UserRole < ApplicationRecord
  belongs_to :user
  belongs_to :roles
  belongs_to :game
end
