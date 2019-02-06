source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end
# Rails gems, no ActionCable
gem "activerecord", '5.0.3'
gem "actionpack"
gem "actionview"
gem "actionmailer"
gem "activejob"
gem "activesupport"
gem "railties"
gem "sprockets-rails"

gem 'awesome_print'
gem 'aws-sdk'
gem 'bootstrap-sass'
gem 'dotenv-rails'
gem 'inline_svg'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'metainspector'
gem 'monban'
gem 'otr-activerecord'
gem 'paperclip'
gem 'pg'
gem 'puma', '~> 3.0'
gem 'pundit'
gem 'sass-rails', '~> 5.0'
gem 'slack-ruby-bot-server', '0.8.3'
gem 'sprockets', '3.7.2'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'

group :development do
  gem 'better_errors'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :development, :test do
  gem 'pry'
  gem 'binding_of_caller'
  gem 'railroady'
end

group :test do
  # gem 'capybara-webkit'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'rspec-rails'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
