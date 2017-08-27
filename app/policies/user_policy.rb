class UserPolicy < ApplicationPolicy
  def show?
    puts "\n\n\n\nUserPolicy show"
    puts "\n\n\n\n"
    
    false
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.where(user: user)
    end
  end
end
