class LinkCreator
  include ErrorCollection
  include Pundit
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

    link
  rescue ActiveRecord::Rollback
    Rails.logger.error "There was a problem creating the link: #{link.errors.full_messages.join(', ')}"
  end

  def tag_users
    link.tagged_users << SlackAccount.where(slack_id: user_tags)
  end

  def create_channel_tag
    channel_tag = find_or_create_tag(channel_name)
    if channel_tag.valid?
      link.tags << channel_tag
    else
      Rails.logger.error "Channel tag couldn't be created: #{channel_tag.errors.full_messages.join(', ')}"
    end
  end

  def add_additional_tags
    tags = hash_tags.map { |tag|  find_or_create_tag(tag) }

    @valid_tags = tags.reject { |tag| tag.class != Tag || !tag.valid? }
    link.tags << @valid_tags

    @invalid_tags = tags.reject { |tag| tag.class != Tag || tag.valid? }
    @invalid_tags.each { |tag| Rails.logger.error "Tag couldn't be created: #{tag.errors.full_messages.join(', ')}"}
  end

  def find_or_create_tag(name)
    Pundit.policy_scope(user_from.user, Tag).where(name: name, team_id: team).first || Tag.create(name: name, slack_account: user_from, team: team)
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
    Rails.logger.error "There was a problem obtaining Metadata for the link: #{e}"
  end
end
