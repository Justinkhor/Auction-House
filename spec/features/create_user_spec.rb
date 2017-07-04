require "rails_helper"

feature "User signs up" do
  scenario "successfully" do
    visit new_user_path

    fill_in "user[first_name]", with: "Test"
    fill_in "user[last_name]", with: "Test"
    fill_in "user[username]", with: "test"
    fill_in "user[email]", with: "test@test.com"
    fill_in "user[password]", with: "test1234"

    click_on "Continue"
    expect(page).to have_content("Auction House")

  end
end
