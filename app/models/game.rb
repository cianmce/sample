class Game < ApplicationRecord
  belongs_to :company
  has_and_belongs_to_many :role
  has_and_belongs_to_many :user
end
