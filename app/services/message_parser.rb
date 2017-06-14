class MessageParser
  CARET_REGEX = /#{'<'}(.*?)#{'>'}/m
  USER_REGEX = /^[@U][A-Z0-9]{9}$/
  HASHTAG_REGEX = /(?:\s|^)(?:#(?!(?:\d+|\w+?_|_\w+?|[\w-]+?_)(?:\s|$)))([\w-]+)(?=\s|$)/i

  def self.parse_urls(text)
    text.scan(CARET_REGEX).
        map { |result| result[0] }.
        reject { |string| USER_REGEX.match?(string)}.
        map { |string| string.split('|').first}
  end

  def self.parse_users(text)
    text.scan(CARET_REGEX).
        map { |result| result[0] }.
        reject { |string| !USER_REGEX.match?(string)}.
        map { |string| string.gsub('@', '') }
  end

  def self.parse_tags(text)
    text.scan(HASHTAG_REGEX).flatten
  end
end
