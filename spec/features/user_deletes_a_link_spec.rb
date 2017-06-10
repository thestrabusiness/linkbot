require 'rails_helper'

feature 'User deletes a link' do
  let!(:user) { create(:user) }
  let!(:other_team_user) { create(:user) }

  before(:each) do
    @link = create(:link, user_from: user)
    @other_team_link = create(:link, user_from: other_team_user)
  end

  context 'as an authenticated user' do
    before(:each) do
      sign_in(user)
    end

    context 'deletes a link posted by their own team' do
      it 'destroys the link record and removes the link from the index page' do
        visit(links_path)
        click_on '(Delete)'

        expect(page).to_not have_content @link.url
        expect(Link.count).to eq 1
      end
    end

    context 'deletes a link posted by another team' do
      it 'redirects the user back to their own link index page' do
        visit(links_path)
        page.driver.submit :delete, "/links/#{@other_team_link.id}", {}

        expect(current_path).to eq links_path
        expect(Link.count).to eq 2
      end
    end
  end

  context 'as an unauthenticated user' do
    it 'redirects to the sign in page' do
      visit root_path
      page.driver.submit :delete, "/links/#{@link.id}", {}
    end
  end
end
