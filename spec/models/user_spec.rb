require 'rails_helper'

RSpec.describe User, type: :model do

  describe "#handle" do
    describe "uniq check" do
      let(:handle) { "captain" }

      before do
        User.create!(handle: handle)
      end

      it "shouldn't allow a new user with the same handle" do
        other_captain = User.new(handle: handle)

        expect(other_captain).to be_invalid
        expect(other_captain.errors.full_messages).to include("Handle has already been taken")
      end

    end
  end


  describe "#failed_logins_count" do
    it "should be 0 as default" do
      captain = User.new(handle: "captain")

      expect(captain.failed_logins_count).to eq(0)
    end
  end
end
