Bundler.require :default

require_relative 'config/environment'
require_relative 'linkbot/bot'
require_relative 'linkbot/linkbot_server'

SlackRubyBotServer::App.instance.prepare!
SlackRubyBotServer::Service.start!

run Rails.application
