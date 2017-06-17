class Team < ApplicationRecord::Base
  has_and_belongs_to_many :slack_accounts
  has_many :tags
  has_many :links
end
