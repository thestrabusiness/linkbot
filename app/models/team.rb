class Team < ApplicationRecord::Base
  has_many :users
  has_many :tags
end
