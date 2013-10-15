require "spec_helper"

describe User do
  let(:good_email) { "test@example.com" }
  let(:bad_email) { "test@example" }
  let(:good_password) { "password123" }
  let(:short_password) { "pass" }
  let(:mismatched_password) { "password12" }
  def login(email, password, confirmation)
    User.new(email: email, password: password, password_confirmation: confirmation)
  end

  it "should accept valid email" do
    user = login(good_email, good_password, good_password)

    expect(user).to be_valid
  end

  it "should reject invalid email" do
    user = login(bad_email, good_password, good_password)

    expect(user).to_not be_valid
  end

  it "should accept matching passwords" do
    user = login(good_email, good_password, good_password)

    expect(user).to be_valid
  end

  it "should reject mismatched passwords" do
    user = login(good_email, good_password, mismatched_password)

    expect(user).to_not be_valid
  end

  it "should reject short passwords" do
    user = login(good_email, short_password, short_password)

    expect(user).to_not be_valid
  end

  it "should not allow duplicate email addresses" do
    user = login(good_email, good_password, good_password)
    user.save
    user2 = login(good_email.capitalize, good_password, good_password)

    expect(user2).to_not be_valid
  end
end