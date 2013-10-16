require 'spec_helper'

describe "PasswordResets" do
  let(:user) { FactoryGirl.create(:user)}
  let(:token) { user.password_resets.create }
  
  it "emails the user when reseting password" do
    visit new_session_url
    within(".content") do
      click_link "Click Here"
    end
    within(".content") do
      fill_in "Email", with: user.email
      click_button "Reset Password"
    end
    
    expect(page).to have_content("Email sent")
  end
  
  it "does not email invalid users when reseting password" do
    visit new_session_url
    within(".content") do
      click_link "Click Here"
    end
    within(".content") do
      fill_in "Email", with: "not@email.com"
      click_button "Reset Password"
    end
    
    expect(page).to have_content("Invalid email address.")
  end
  
  it "shows the password reset page for a valid token" do
    visit edit_password_reset_url(id: token.token)
    
    expect(page).to have_content("Reset Password for #{user.email}")
  end
  
  it "changes the password successfully" do
    visit edit_password_reset_url(id: token.token)
    
    within(".content") do
      fill_in "Password", with: "newpassword"
      fill_in "Password Confirmation", with: "newpassword"
    end
    
    click_button "Save"
    
    visit new_session_url
    within(".content") do
      fill_in "Email", with: user.email
      fill_in "Password", with: "newpassword"
      click_button "Login"
    end
    
    expect(page).to have_content("Welcome back")
  end
end
