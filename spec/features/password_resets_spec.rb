require 'spec_helper'

describe "PasswordResets" do
  it "emails the user when reseting password" do
    user = FactoryGirl.create(:user)
    visit new_session_url
    within(".content") do
      click_link "Click Here"
    end
    within(".content") do
      fill_in "Email", with: user.email
      click_button "Reset Password"
    end
    
    expect(page).to have_content("Email sent")
    expect(last_email.to).to include(user.email)
  end
end
