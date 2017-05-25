class User < ActiveRecord::Base
  friendly_id :slug, use: :slugged
end
