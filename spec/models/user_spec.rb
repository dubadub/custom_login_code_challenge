require 'rails_helper'

RSpec.describe User, type: :model do
  let(:handle) { "captain" }
  let(:captain) { described_class.new(handle: handle) }

  describe "#handle" do
    describe "uniq check" do
      before do
        captain.password = "my secret password"
        captain.save!
      end

      it "shouldn't allow a new user with the same handle" do
        other_captain = described_class.new(handle: handle)

        expect(other_captain).to be_invalid
        expect(other_captain.errors.full_messages).to include("Handle has already been taken")
      end

    end
  end

  describe "#failed_logins_count" do
    it "should be 0 as default" do
      expect(captain.failed_logins_count).to eq(0)
    end
  end

  describe "#password" do
    let(:password) { "my_password" }

    before { captain.password = password }

    it "encrypts password" do
      expect(captain.encrypted_password).to_not eq(password)
    end

    it "adds salt (a new hash for the same password)" do
      previous_encrypted_password = captain.password
      captain.password = password
      expect(captain.encrypted_password).to_not eq(previous_encrypted_password)
    end

    it "properly compares passwords" do
      expect(captain.password).to eq(password)
      expect(captain.password).to_not eq(password.reverse)
    end
  end
end
