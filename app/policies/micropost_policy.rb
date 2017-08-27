class MicropostPolicy < ApplicationPolicy

  def show?
    puts "\n\n\n\n"
    puts "MicropostPolicy show"
    puts "\n\n\n\n"
    false
  end


  def something_else?

    puts "\n\n\n\n"
    puts "MicropostPolicy something_else?"
    puts @user.name
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
