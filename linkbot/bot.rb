class Bot < SlackRubyBot::Bot
  command 'say' do |client, data, match|
    client.say(channel: data.channel, text: match['expression'])
  end
end

class SlackRubyBot::Commands::Unknown
  def self.call(client, data, _match)

  end
end
