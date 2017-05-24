Bundler.require :default

require_relative 'linkbot/bot'
require_relative 'linkbot/linkbot_server'

require_relative 'config/environment'

SlackRubyBotServer::App.instance.prepare!
SlackRubyBotServer::Service.start!

run Rails.application
