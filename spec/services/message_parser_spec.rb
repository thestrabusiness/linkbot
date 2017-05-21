require 'rails_helper'

describe 'MessageParser' do
  describe '#parse_links' do
    context 'when the message text contains URLs' do
      it 'returns an array containing only the links' do
        one_url_message_text = 'Here’s one link <http://www.testlink.com>'
        two_url_message_text = 'Here’s two links <http://www.testlink.com> <http://compile.this>'
        message_text_with_user = 'This message has a user <http://www.testlink.com> <@U5F4HRNUX>'

        expect(MessageParser.parse_urls(one_url_message_text)).to eq ['http://www.testlink.com']
        expect(MessageParser.parse_urls(two_url_message_text)).to eq ['http://www.testlink.com', 'http://compile.this']
        expect(MessageParser.parse_urls(message_text_with_user)).to eq ['http://www.testlink.com']
      end
    end

    context 'when the message text does not contain a URL' do
      it 'renders an empty array' do
        no_url_message_text = 'Here\'s a regular message! <@U583HSEQX>'

        expect(MessageParser.parse_urls(no_url_message_text)).to eq []
      end
    end
  end

  describe '#parse_users' do
    context 'when the message text contains tagged users' do
      it 'returns an array containing only the tagged users without the @' do
        one_user_message_text = 'This message has a user <@U5F4HRNUX>'
        two_user_message_text = 'How about two users <@U5F4HRNUX> <@U583HSEQX>'
        user_message_text_with_url = 'This message has a user and a link <http://www.testlink.com> <@U5F4HRNUX>'

        expect(MessageParser.parse_users(one_user_message_text)).to eq ['U5F4HRNUX']
        expect(MessageParser.parse_users(two_user_message_text)).to eq ['U5F4HRNUX', 'U583HSEQX']
        expect(MessageParser.parse_users(user_message_text_with_url)).to eq ['U5F4HRNUX']
      end
    end

    context 'when the message text does not contain a user' do
      it 'returns an empty array' do
        no_user_message_text = 'Here\'s a message without a tagged used'

        expect(MessageParser.parse_users(no_user_message_text)).to eq []
      end
    end
  end
end
