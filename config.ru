Bundler.require :default

require_relative 'config/environment'
require_relative 'bot/bot'

SlackRubyBotServer::App.instance.prepare!
SlackRubyBotServer::Service.start!

run SlackRubyBotServer::Api::Middleware.instance

