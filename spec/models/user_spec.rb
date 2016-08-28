require 'spec_helper'

RSpec.describe User, type: :model do
  it "is valid with valid attributes" do
    expect(User.new(email: 'test3@mail.com', password: 'test', token: 'wewevdrv-79vf-vre')).to be_valid
  end
  it { is_expected. to validate_presence_of(:email).with_message(/must be filled/) }
  it { is_expected. to validate_presence_of(:password).with_message(/must be filled/) }
  it { is_expected. to allow_value("email@addresse.foo").for(:email) }
  it "is not valid with wrong format of email" do
    expect(User.new(email: 'rvgesgv.ger', password: 'ewfg', token: 'gedrgvrev')).to_not be_valid
  end

  # describe 'email validation' do
  #   before { User.create(email: 'test@test.com', password: '4evdve', token: 'vebebgervrebedrb') }
  #   it "is not valid with duplicating email" do
  #     expect(User.new(email: 'test@test.com', password: '4evdve', token: 'vebebgervrebedrb')).to_not be_valid
  #   end
  # end

  it { is_expected.to validate_uniqueness_of(:email).with_message(/already exists/) }
end
