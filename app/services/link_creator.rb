class LinkCreator
  include ErrorCollection
  attr_accessor :url, :user_from, :team, :user_tags, :hash_tags, :channel_name

  def initialize(url:, user_from:, slack_team_id:, hash_tags:, user_tags:, channel_name:)
    @url = url
    @user_from = user_from
    @hash_tags = hash_tags
    @user_tags = user_tags
    @channel_name = channel_name
    @team = Team.find_by_team_id(slack_team_id)
  end

  def self.perform(url:, user_from:, slack_team_id:, hash_tags:, user_tags:, channel_name:)
    new(url: url,
        user_from: user_from,
        slack_team_id: slack_team_id,
        hash_tags: hash_tags,
        user_tags: user_tags,
        channel_name: channel_name).perform
  end

  def perform
    ActiveRecord::Base.transaction do
      get_metadata
      tag_users if user_tags.present?

      link.save

      if link.errors.any?
        raise ActiveRecord::Rollback
      end
    end

    create_channel_tag
    add_additional_tags if hash_tags.present?

  rescue ActiveRecord::Rollback
    logger.error "There was a problem creating the link #{link.errors.inspect}"
  end

  def tag_users
    link.tagged_users << SlackAccount.where(slack_id: user_tags)
  end

  def create_channel_tag
    link.tags << find_or_create_tag(channel_name)
  end

  def add_additional_tags
    @additional_tags = hash_tags
                           .map { |tag|  find_or_create_tag(tag) }
                           .reject{ |tag| tag.class != Tag || !tag.valid? }

    link.tags << @additional_tags
  end

  def find_or_create_tag(name)
    policy_scope(Tag).find_by_name(name) || Tag.create(name: name, slack_user: user_from, team: team)
  end

  def link
    @link ||= Link.new(url: url, user_from: user_from, team: team)
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

  rescue MetaInspector::Error, MetaInspector::TimeoutError, MetaInspector::RequestError, MetaInspector::ParserError => e
    logger.error "There was a problem obtaining Metadata for the link: #{e}"
  end
end
