class MessageParser
  CARET_REGEX = /#{'<'}(.*?)#{'>'}/m
  USER_REGEX = /^[@U][A-Z0-9]{9}$/
  HASHTAG_REGEX = /(?:\s|^)(?:#(?!(?:\d+|\w+?_|_\w+?|[\w-]+?_)(?:\s|$)))([\w-]+)(?=\s|$)/i

  attr_accessor :text, :parsed_message

  def self.links_present?(text)
    new(text).scan_text_for_links.present?
  end

  def self.perform(text)
    new(text).perform
  end

  def initialize(text)
    @text = text
    @parsed_message = {}
  end

  def perform
    parse_urls
    parse_users
    parse_tags

    parsed_message
  end

  def scan_text_for_links
    text.scan(CARET_REGEX)
        .map { |result| result[0] }
        .reject { |string| USER_REGEX.match?(string) }
        .map { |string| string.split('|').first }
  end

  def parse_urls
    parsed_message[:urls] = scan_text_for_links
  end

  def parse_users
    parsed_message[:users] = text.scan(CARET_REGEX)
                                 .map { |result| result[0] }
                                 .reject { |string| !USER_REGEX.match?(string) }
                                 .map { |string| string.gsub('@', '') }
  end

  def parse_tags
    parsed_message[:tags] = text.scan(HASHTAG_REGEX).flatten
  end
end
