class Team < ApplicationRecord::Base
  has_and_belongs_to_many :users
  has_many :tags
  has_many :links
end
