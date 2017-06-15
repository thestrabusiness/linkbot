class LinkbotServer < SlackRubyBotServer::Server
  on :team_join do |_, data|
    User.find_by_slack_id(data.user) || UserCreator.perform(data.user, data.team)
  end

  on :message do |client, data|
    MessageParser.links_present?(data.text) ? parsed_message = MessageParser.perform(data.text) : parsed_message = {}

    if parsed_message[:urls].present?
      user_from = User.find_by_slack_id(data.user)

      parsed_message[:urls].each do |url|
        link = Link.create(
            url: url,
            user_from: user_from
        )

        link.tagged_users << User.where(slack_id: parsed_message[:users]) if parsed_message[:users].present?

        Tag.create(name: data.channel.name, link: link, user: user_from, team: user_from.team)

        if tags.present?
          tags.each do |tag|
            Tag.create(name: tag, link: link, user: user_from, team: user_from.team)
          end
        end

      end

      client.say(
          channel: data.channel,
          text: "Link".pluralize(urls.count) + " saved to db"
      )
    end
  end
end
