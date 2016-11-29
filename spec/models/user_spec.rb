require 'spec_helper'

describe User, type: :model do

  describe 'Database' do
    it { is_expected.to have_db_column(:email).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:password).of_type(:string).with_options(null: false) }
  end

  describe 'Validations' do
    it "is valid with valid attributes" do
      expect(User.new(email: 'test3@mail.com', password: 'test', token: 'wewevdrv-79vf-vre')).to be_valid
    end
    it { is_expected. to validate_presence_of(:email).with_message(/must be filled/) }
    it { is_expected. to validate_presence_of(:password).with_message(/must be filled/) }
    it { is_expected. to allow_value("email@addresse.foo").for(:email) }
    it "is not valid with wrong format of email" do
      expect(User.new(email: 'rvgesgv.ger', password: 'ewfg', token: 'gedrgvrev')).to_not be_valid
    end

    it { is_expected.to validate_uniqueness_of(:email).with_message(/already exists/) }
  end
end
