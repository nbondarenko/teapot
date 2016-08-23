require 'spec_helper'

RSpec.describe User, :type => :model do
  it "is valid with valid attributes" do
    expect(User.new(email: 'test3@mail.com', password: 'test', token: 'wewevdrv-79vf-vre')).to be_valid
  end
  it "is not valid without an email"
  it "is not valid without a password"
  it "is not valid with wrong format of email"
end
