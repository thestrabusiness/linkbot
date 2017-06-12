class LinkPolicy
  attr_reader :user, :link

  def initialize(user, link)
    @user = user
    @link = link
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      scope
          .joins(user_from: :team)
          .where('users.team_id': user.team.id)
          .includes(:metadata)
    end
  end

  def show?
    link_belongs_to_users_team?
  end

  def destroy?
    link_belongs_to_users_team?
  end

  private

  def link_belongs_to_users_team?
    user.team == link.team
  end
end
