class UserTag < ActiveRecord::Base
  belongs_to :link
  belongs_to :slack_account
end
