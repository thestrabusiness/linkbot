class LinkbotServer < SlackRubyBotServer::Server
  on :team_join do |client, data|
    puts client
    puts data
    #UserCreator.perform(something)
  end

  on :message do |client, data|
   if Rails.env == 'development'
     puts '-'*70
     puts data
     puts '-'*70
   end

    urls = MessageParser.parse_urls(data.text)
    users = MessageParser.parse_users(data.text)

    if urls.present?
      urls.each do |url|
        link = Link.create(
            url: url,
            user_from: User.find_by_slack_id(data.user)
        )
      end

      client.say(
          channel: data.channel,
          text: "link".pluralize(urls.count) + " saved to db"
      )
    end
  end
end
