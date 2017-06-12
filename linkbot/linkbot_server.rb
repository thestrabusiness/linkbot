class LinkbotServer < SlackRubyBotServer::Server
  on :team_join do |_, data|
    User.find_by_slack_id(data.user) || UserCreator.perform(data.user, data.team)
  end

  on :message do |client, data|
    urls = MessageParser.parse_urls(data.text)
    users = MessageParser.parse_users(data.text)

    if urls.present?
      urls.each do |url|
        link = Link.create(
            url: url,
            user_from: User.find_by_slack_id(data.user)
        )

        link.tagged_users << User.where(slack_id: users)
      end

      client.say(
          channel: data.channel,
          text: "Link".pluralize(urls.count) + " saved to db"
      )
    end
  end
end
