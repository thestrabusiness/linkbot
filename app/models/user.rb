class User < ActiveRecord::Base
  belongs_to :team

  validates :slack_id, presence: true, uniqueness: true

  def full_name
    [first_name, last_name].join(' ')
  end
end
