class LinkbotServer < SlackRubyBotServer::Server
  on :message do |client, data|
   if Rails.env == 'development'
     puts '-'*70
     puts data
     puts '-'*70
   end

    urls = MessageParser.parse_urls(data.text)
    # for now we don't have a way to save multiple users to a link, so let's just take the first
    users = MessageParser.parse_users(data.text).first

    if urls.present?
      urls.each { |url| Link.create(url: url, user_from: data.user , user_to: users) }
      client.say(channel: data.channel, text: "link".pluralize(urls.count) + " saved to db")
    end
  end
end
