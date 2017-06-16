class LinkCreator
  include ErrorCollection
  attr_accessor :url, :user_from, :user_tags, :hash_tags, :channel_name

  def initialize(url:, user_from:, hash_tags:, user_tags:, channel_name:)
    @url = url
    @user_from = user_from
    @hash_tags = hash_tags
    @user_tags = user_tags
    @channel_name = channel_name
  end

  def self.perform(url:, user_from:, hash_tags:, user_tags:, channel_name:)
    new(url: url,
        user_from: user_from,
        hash_tags: hash_tags,
        user_tags: user_tags,
        channel_name: channel_name).perform
  end

  def perform
    ActiveRecord::Base.transaction do
      get_metadata
      tag_users if user_tags.present?
      create_channel_tag
      add_additional_tags if hash_tags.present?

      link.save

      if link.errors.any?
        raise ActiveRecord::Rollback
      end
    end

  rescue ActiveRecord::Rollback
    logger.error "There was a problem creating the link #{link.errors.inspect}"
  end

  def tag_users
    link.tagged_users << User.where(slack_id: user_tags)
  end

  def create_channel_tag
    link.tags << Tag.create(name: channel_name, user: user_from, team: user_from.team)
  end

  def add_additional_tags
    @additional_tags = hash_tags
                           .map { |tag|  find_or_create_tag(tag) }
                           .reject{ |tag| tag.class != Tag || !tag.valid? }

    link.tags << @additional_tags
  end

  def find_or_create_tag(name)
    policy_scope(Tag).find_by_name(name) || Tag.create(name: name, user: user_from, team: user_from.team)
  end

  def link
    @link ||= Link.new(url: url, user_from: user_from)
  end

  def get_metadata
    existing_metadata = Metadata.find_by_url(link.url)

    if existing_metadata.present?
      link.metadata = existing_metadata
    else
      meta_inspector = MetaInspector.new(link.url)

      metadata = Metadata.create(
          url: url,
          title: meta_inspector.best_title,
          description: meta_inspector.best_description,
          domain: meta_inspector.host,
          image: meta_inspector.images.best
      )

      if metadata.errors.empty?
        link.metadata = metadata
      else
        link.collect_errors_from metadata
      end
    end
  end
end
