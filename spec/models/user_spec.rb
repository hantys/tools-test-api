require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:user3) { create(:user) }
  let(:user) { build(:user) }

  it { is_expected.to have_many(:tasks).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to validate_confirmation_of(:password) }
  # verifica se o email digitado e valido
  it { is_expected.to allow_value("fasd@.com").for(:email) }
  it { is_expected.to allow_value("111132").for(:password) }
  it { is_expected.to validate_uniqueness_of(:auth_token) }
  it { is_expected.not_to allow_value(user2.auth_token).for(:auth_token) }

  describe "#info" do
    let(:user) { build(:user) }
    it "return email, created_at and auth_token" do
      user.save!
      allow(Devise).to receive(:friendly_token).and_return("ZDwt1eN4xD8J7P-8Tf9a")

      expect(user.info).to  eq("#{user.email} - #{user.created_at} - Token: #{Devise.friendly_token}")
    end
  end

  describe "#generete_authentication_token!" do
    it "generete unique token" do
      allow(Devise).to receive(:friendly_token).and_return("ZDwt1eN4xD8J7P-8Tf9a")
      user.generete_authentication_token!

      expect(user.auth_token).to  eq("ZDwt1eN4xD8J7P-8Tf9a")
    end

    it "generete another token when the current token already has been taken" do
      allow(Devise).to receive(:friendly_token).and_return("asdss12345", "asdss12345", "1234-8Tf9a")
      user_existing = create(:user)
      user.generete_authentication_token!

      expect(user.auth_token).not_to  eq(user_existing.auth_token)
    end
  end
end
