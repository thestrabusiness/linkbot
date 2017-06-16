class Link < ActiveRecord::Base
  belongs_to :user_from, class_name: 'User'
  has_one :team, through: :user_from
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :tagged_users, class_name: 'User', join_table: 'user_tags'
  belongs_to :metadata

  delegate :image, to: :metadata, allow_nil: true
  delegate :title, to: :metadata, allow_nil: true
  delegate :domain, to: :metadata, allow_nil: true
  delegate :description, to: :metadata, allow_nil: true

  after_create :find_or_create_link_metadata

  def find_or_create_link_metadata
    metadata = Metadata.find_by_url(self.url)

    if metadata.present?
      self.update(metadata: metadata)
    else
      MetadataCreator.perform(self)
    end
  end
end
