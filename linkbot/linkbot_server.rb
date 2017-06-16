class LinkbotServer < SlackRubyBotServer::Server
  include Pundit

  on :team_join do |_, data|
    User.find_by_slack_id(data.user) || UserCreator.perform(data.user, data.team)
  end

  on :message do |client, data|
    channel_name = get_channel_name(client.web_client, data.channel)
    user_from = User.find_by_slack_id(data.user)

    if MessageParser.links_present?(data.text)
      parsed_message = MessageParser.perform(data.text)

      parsed_message[:urls].each do |url|
        LinkCreator.perform(url: url,
                            user_from: user_from,
                            hash_tags: parsed_message[:tags],
                            user_tags: parsed_message[:users],
                            channel_name: channel_name
        )
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
