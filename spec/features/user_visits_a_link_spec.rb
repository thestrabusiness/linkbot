require 'rails_helper'

feature 'User visits a link' do
  let(:user) { create(:user) }
  let(:other_team_user) { create(:user) }
  let(:link) { create(:link, user_from: user.slack_accounts.first, team: user.active_team) }
  let(:other_team_link) { create(:link, user_from: other_team_user.slack_accounts.first, team: other_team_user.active_team) }

  context 'as an authenticated user' do
    before(:each) do
      sign_in(user)
    end

    context 'visits a link posted by their own team' do
      it 'redirects the user to the destination url' do
        visit(link_path(link))
        expect(current_url).to include link.url
      end
    end

    context 'visits a link posted by another team' do
      it 'redirects the user back to their own link index page' do
        visit(link_path(other_team_link))
        expect(current_path).to eq links_path
      end
    end
  end

  context 'as an unauthenticated user' do
    it 'redirects them to the sign in page' do
      visit(link_path(link))
      expect(current_path).to eq new_session_path
    end
  end
end
