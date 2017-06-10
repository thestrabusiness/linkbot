class User < ActiveRecord::Base
  belongs_to :team
  has_and_belongs_to_many :tagged_links, class_name: 'Link', join_table: 'user_tags'

  validates :slack_id, presence: true, uniqueness: true

  def full_name
    [first_name, last_name].join(' ')
  end
end
