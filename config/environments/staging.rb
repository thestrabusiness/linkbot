Rails.application.configure do
  config.log_level = :debug
  config.log_formatter = ::Logger::Formatter.new
  config.logger = Logger.new(STDOUT)
end
