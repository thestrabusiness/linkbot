class SlackAccountUserQuerier
  attr_accessor :email, :slack_user_id, :slack_team_id, :accounts

  def self.perform(email:, slack_user_id:, slack_team_id:)
    new(email: email,
        slack_user_id: slack_user_id,
        slack_team_id: slack_team_id
    ).perform
  end

  def initialize(email:, slack_user_id:, slack_team_id:)
    @email = email
    @slack_user_id = slack_user_id
    @slack_team_id = slack_team_id
    @accounts = SlackAccount.where(email: email)
  end

  def perform
    if accounts.present? && any_account_matches_login?
      user.update(active_team: matching_account.team) if matching_account.present?
      user
    elsif accounts.present? && !any_account_matches_login?
      SlackAccount.create(
                      user: user,
                      team: team,
                      slack_id: slack_user_id,
                      email: email
      )

      user.update(active_team: team)
      user
    else
      nil
    end
  end

  def team
    Team.find_by_team_id(slack_team_id)
  end

  def user
    accounts.first.user
  end

  def any_account_matches_login?
    accounts.any? { |a| a.team == team && a.slack_id == slack_user_id }
  end

  def matching_account
    if any_account_matches_login?
      accounts.select { |a| a if a.team == team && a.slack_id == slack_user_id }.first
    end
  end
end
