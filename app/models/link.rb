class Link < ActiveRecord::Base
  friendly_id :slug, use: :slugged
end
