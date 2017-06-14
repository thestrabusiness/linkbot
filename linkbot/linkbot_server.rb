class LinkbotServer < SlackRubyBotServer::Server
  on :team_join do |_, data|
    User.find_by_slack_id(data.user) || UserCreator.perform(data.user, data.team)
  end

  on :message do |client, data|
    urls = MessageParser.parse_urls(data.text)
    users = MessageParser.parse_users(data.text)
    tags = MessageParser.parse_tags(data.text)

    if urls.present?
      user_from = User.find_by_slack_id(data.user)

      urls.each do |url|
        link = Link.create(
            url: url,
            user_from: user_from
        )

        link.tagged_users << User.where(slack_id: users)

        Tag.create(name: data.channel.name, link: link, user: user_from, team: user_from.team)

        tags.each do |tag|
          Tag.create(name: tag, link: link, user: user_from, team: user_from.team)
        end
      end

      client.say(
          channel: data.channel,
          text: "Link".pluralize(urls.count) + " saved to db"
      )
    end
  end
end
