require 'rails_helper'

feature 'User visits the link index page' do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  context 'with an authenticated session' do
    it 'renders only links posted by a the user\'s team'do
      authorized_link = create(:link, user_from: user.slack_accounts.first, url: 'www.google.com', team: user.active_team)
      unauthorized_link = create(:link, user_from: other_user.slack_accounts.first, url: 'www.facebook.com', team: other_user.active_team)

      sign_in(user)
      visit links_path

      expect(page).to have_content authorized_link.url

      expect(page).to_not have_content unauthorized_link.url
    end
  end

  context 'without an authenticated session' do
    it 'redirects the user to the sign-in page' do
      visit links_path

      expect(current_path).to eq new_session_path
    end
  end
end
