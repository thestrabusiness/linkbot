class Tag < ActiveRecord::Base
  belongs_to :user
  belongs_to :team
  belongs_to :link

  validates :name, presence: true
end
