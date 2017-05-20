class LinkbotServer < SlackRubyBotServer::Server
  LINK_REGEX = /((http|https):\/\/[a-z0-9]+([\-.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?)/

  on :message do |client, data|
    link = data.text.scan(LINK_REGEX)
    if link.present?
      Link.create(url: link.first.first)
      client.say(channel: data.channel, text: "link saved to db")
    end
  end
end
