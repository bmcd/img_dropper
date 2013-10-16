require 'spec_helper'

describe PasswordReset do
  it "should have set a token before validation" do
    pr = PasswordReset.new(user_id: 1)
    expect(pr).to be_valid
  end
end
