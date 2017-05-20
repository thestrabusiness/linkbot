require_relative '../../linkbot/linkbot_server'

SlackRubyBotServer.configure do |config|
  config.server_class = LinkbotServer
end
