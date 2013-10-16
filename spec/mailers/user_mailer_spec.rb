require "spec_helper"

describe UserMailer do
  describe "password_reset" do
    let(:user) { FactoryGirl.create(:user)}
    let(:token) { user.password_resets.create }
    let(:mail) { UserMailer.password_reset(user, token) }

    it "sends user the password reset url" do
      mail.subject.should eq("Password Reset")
      mail.to.should eq([user.email])
      mail.from.should eq(["no-reply@imgdropper.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match(edit_password_reset_url(token))
    end
  end

end
