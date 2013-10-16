require 'spec_helper'

describe "PasswordResets" do
  it "emails the user when reseting password" do
    user = FactoryGirl.create(:user)
    visit new_session_url
    click_link "password"
    fill_in "Email", with: user.email
    click_button "Reset Password"
    
    expect(page).to have_content("Email sent")
    expect(last_email.to).to include(user.email)
  end
end
