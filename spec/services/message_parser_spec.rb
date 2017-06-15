require 'rails_helper'

describe 'MessageParser' do
  describe '#parse_links' do
    context 'when the message text contains URLs' do
      it 'returns an array containing only the links' do
        one_url_message_text = 'Here’s one link <http://www.testlink.com>'
        two_url_message_text = 'Here’s two links <http://www.testlink.com> <http://compile.this>'
        message_text_with_user = 'This message has a user <http://www.testlink.com> <@U5F4HRNUX>'

        expect(MessageParser.perform(one_url_message_text)[:urls]).to eq ['http://www.testlink.com']
        expect(MessageParser.perform(two_url_message_text)[:urls]).to eq ['http://www.testlink.com', 'http://compile.this']
        expect(MessageParser.perform(message_text_with_user)[:urls]).to eq ['http://www.testlink.com']
      end
    end

    context 'when the message text does not contain a URL' do
      it 'renders an empty array' do
        no_url_message_text = 'Here\'s a regular message! <@U583HSEQX>'

        expect(MessageParser.perform(no_url_message_text)[:urls]).to eq []
      end
    end
  end

  describe '#perform' do
    context 'when the message text contains tagged users' do
      it 'returns an array containing only the tagged users without the @' do
        one_user_message_text = 'This message has a user <@U5F4HRNUX>'
        two_user_message_text = 'How about two users <@U5F4HRNUX> <@U583HSEQX>'
        user_message_text_with_url = 'This message has a user and a link <http://www.testlink.com> <@U5F4HRNUX>'

        expect(MessageParser.perform(one_user_message_text)[:users]).to eq ['U5F4HRNUX']
        expect(MessageParser.perform(two_user_message_text)[:users]).to eq ['U5F4HRNUX', 'U583HSEQX']
        expect(MessageParser.perform(user_message_text_with_url)[:users]).to eq ['U5F4HRNUX']
      end
    end

    context 'when the message text does not contain a user' do
      it 'returns an empty array' do
        no_user_message_text = 'Here\'s a message without a tagged used'

        expect(MessageParser.perform(no_user_message_text)[:users]).to eq []
      end
    end
  end

  describe '#perform' do
    context 'when the message text contains a hashtag' do
      it 'returns an array of the tags without #' do
        message = 'Here’s two links <http://www.testlink.com> <http://compile.this> #cool-links'

        expect(MessageParser.perform(message)[:tags]).to eq ['cool-links']
      end
    end
  end
end
