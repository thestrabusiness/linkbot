class LinkbotServer < SlackRubyBotServer::Server
  include Pundit

  on :team_join do |_, data|
    User.find_by_slack_id(data.user) || UserCreator.perform(data.user, data.team)
  end

  on :message do |client, data|

    channel_name = get_channel_name(client.web_client, data.channel)

    MessageParser.links_present?(data.text) ? parsed_message = MessageParser.perform(data.text) : parsed_message = {}

    if parsed_message[:urls].present?
      user_from = User.find_by_slack_id(data.user)

      parsed_message[:urls].each do |url|
        link = Link.create(
            url: url,
            user_from: user_from
        )

        link.tagged_users << User.where(slack_id: parsed_message[:users]) if parsed_message[:users].present?

        link.tags << Pundit.policy_scope(user_from, Tag).find_by_name(channel_name) || Tag.create(name: channel_name, user: user_from, team: user_from.team)

        if parsed_message[:tags].present?
          parsed_message[:tags].each do |tag|
            link.tags << Pundit.policy_scope(user_from, Tag).find_by_name(tag) || Tag.create(name: tag, user: user_from, team: user_from.team)
          end
        end
      end

      client.say(
          channel: data.channel,
          text: "Link".pluralize(parsed_message[:urls].count) + " saved to db"
      )
    end
  end

  def self.get_channel_name(client, channel)
    #public channel?
    return client.channels_info(channel: channel).channel['name'] if channel.start_with? 'C'

    #private group?
    return client.groups_info(channel: channel).channel['name'] if channel.start_with? 'G'
  end
end
