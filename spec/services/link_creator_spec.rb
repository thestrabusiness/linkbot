require 'rails_helper'

describe LinkCreator do
  let!(:user) { create(:user, :with_slack_account) }
  let!(:tagged_slack_user) { create(:slack_account, :with_user) }

  describe '#perform' do
    context 'with all argument keywords present' do
      context 'such as a single link' do
        context 'without any tags' do
          it 'saves the link to the database' do
            expect {
              LinkCreator.perform(
                  url: 'google.com',
                  user_from: SlackAccount.first,
                  hash_tags: [''],
                  user_tags: [''],
                  channel_name: 'Channel',
                  slack_team_id: Team.first.team_id
              )
            }.to change{ Link.count }.to(1)
          end
        end

        context 'with user tags' do
          it 'saves the user tags and associates them with the link' do
            tagged_id = tagged_slack_user.slack_id

            link = LinkCreator.perform(
                url: 'google.com',
                user_from: SlackAccount.first,
                hash_tags: [''],
                user_tags: [tagged_id],
                channel_name: 'Channel',
                slack_team_id: tagged_slack_user.user.active_team_id
            )


            expect(link.class).to eq Link
            expect(link.tagged_users).to include tagged_slack_user
          end
        end

        context 'with hashtags' do
          it 'saves the hashtags and associates them with the link' do
            tags_array = ['cool', 'wow', 'tags']

            link = LinkCreator.perform(
                url: 'google.com',
                user_from: SlackAccount.first,
                hash_tags: tags_array,
                user_tags: [''],
                channel_name: 'Channel',
                slack_team_id: tagged_slack_user.user.active_team_id
            )

            expect(link.class).to eq Link

            tags_array.each do |tag|
              expect(
                  link.tags.collect { |t| t.name }
              ).to include tag
            end
          end
        end
      end
    end
  end
end
