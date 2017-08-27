class Role < ApplicationRecord
  belongs_to :company
  has_and_belongs_to_many :permissions

  has_many :user_roles
  has_many :users, through: :user_roles


  alias_method :restricted_to_company, :company
end
