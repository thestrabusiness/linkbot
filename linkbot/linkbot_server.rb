class LinkbotServer < SlackRubyBotServer::Server
  on :team_join do |client, data|
    user_email = get_user_email(client.web_client, data.user)
    SlackAccount.slack_find(data.user, get_team_id(data.team)) || UserCreator.perform(data.user, data.team, user_email)
  end

  on :message do |client, data|
    if data.text.present? && MessageParser.links_present?(data.text)
      channel_name = get_channel_name(client.web_client, data.channel)
      user_from = SlackAccount.slack_find(data.user, get_team_id(data.team))

      parsed_message = MessageParser.perform(data.text)

      parsed_message[:urls].each do |url|
        LinkCreator.perform(url: url,
                            user_from: user_from,
                            slack_team_id: data.team,
                            hash_tags: parsed_message[:tags],
                            user_tags: parsed_message[:users],
                            channel_name: channel_name
        )
      end

      if Rails.env.development?
        client.say(
            channel: data.channel,
            text: "Link".pluralize(parsed_message[:urls].count) + " saved to db"
        )
      end
    end
  end


  def self.get_channel_name(client, channel)
    #public channel?
    return client.channels_info(channel: channel).channel['name'] if channel.start_with? 'C'

    #private group?
    return client.groups_info(channel: channel).channel['name'] if channel.start_with? 'G'
  end


  def self.get_user_email(client, slack_user_id)
    client.users_identity(user: slack_user_id).user.email
  end

  def self.get_team_id(team_id)
    Team.find_by_team_id(team_id).id
  end
end
