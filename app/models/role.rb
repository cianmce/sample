class Role < ApplicationRecord
  belongs_to :company
  alias_method :restricted_to_company, :company
end
