class Tag < ActiveRecord::Base
  belongs_to :user
  belongs_to :team
  has_and_belongs_to_many :links

  validates :name, presence: true, uniqueness: :team
end
