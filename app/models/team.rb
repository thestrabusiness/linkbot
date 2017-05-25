class Team < ApplicationRecord::Base
  has_many :users
end
