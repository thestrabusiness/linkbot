require 'rails_helper'

feature 'User visits the link index page' do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  context 'with an authenticated session' do
    it 'renders only links posted by a the user\'s team'do
      authorized_links = create_list(:link, 3, user_from: user)
      unauthorized_links = create_list(:link, 3, user_from: other_user)

      sign_in(user)
      visit links_path

      authorized_links.each do |link|
        expect(page).to have_content link.url
      end

      unauthorized_links.each do |link|
        expect(page).to_not have_content link.url
      end
    end
  end

  context 'without an authenticated session' do
    it 'redirects the user to the sign-in page' do
      visit links_path

      expect(current_path).to eq new_session_path
    end
  end
end
