class Metadata < ActiveRecord::Base
  has_attached_file :image
  has_many :links

  validates_attachment :image, content_type: { content_type: /^image\/(png|gif|jpeg)/ }
end
