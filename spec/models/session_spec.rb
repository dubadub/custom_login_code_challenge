require 'rails_helper'

RSpec.describe Session, type: :model do

  describe "#initializer" do
    context "without arguments" do
      it "creates new object" do
        expect(described_class.new).to be_truthy
      end
    end

    context "with handle and password" do
      it "creates new object" do
        expect(described_class.new(handle: "handle", password: "password")).to be_truthy
      end
    end
  end

  describe "#save" do

    context "when valid credentials passed" do
      let(:handle) { "good_captain" }
      let(:password) { "good_password!" }
      let!(:user) { User.create!(handle: handle, password: password) }

      it "successfully saves session" do
        session = described_class.new(handle: handle, password: password)

        expect(session.save).to be_truthy
      end

      context "when user previously had failed logins" do
        before { user.update!(failed_logins_count: 1) }

        it "resets failed_logins_count" do
          session = described_class.new(handle: handle, password: password)

          expect { session.save }.to change { user.reload.failed_logins_count }.to(0)
        end
      end

      context "when user was locked" do
        before { user.update!(failed_logins_count: 3) }

        it "doesn't create session" do
          session = described_class.new(handle: handle, password: password)

          expect(session.save).to be_falsey
          expect(session.errors.full_messages).to include(I18n.t("sessions.we_locked_account"))
        end
      end
    end

    context "when invalid credentials passed" do
      context "when handle is not in database" do
        it "fails to save session and adds an error message" do
          session = described_class.new(handle: "handle", password: "password")

          expect(session.save).to be_falsey
          expect(session.errors.full_messages).to include(I18n.t("sessions.user_not_found"))
        end
      end

      context "when handle is in database" do
        let(:handle) { "forgetful_captain" }
        let(:password) { "forgotten_password!" }
        let!(:user) { User.create!(handle: handle, password: password) }

        it "fails to save session and adds an error message" do
          session = described_class.new(handle: handle, password: "gibberish_password")

          expect(session.save).to be_falsey
          expect(session.errors.full_messages).to include(I18n.t("sessions.user_not_found"))
        end

        describe "account locking" do
          it "doesn't reveal that problem with password after first attempt" do
            session = described_class.new(handle: handle, password: "gibberish_password")

            expect(session.save).to be_falsey
            expect(session.errors.full_messages).to include(I18n.t("sessions.user_not_found"))
          end

          it "warns that problem with password on the second attempt" do
            user.update!(failed_logins_count: 1)

            session = described_class.new(handle: handle, password: "gibberish_password")

            expect(session.save).to be_falsey
            expect(session.errors.full_messages).to include(I18n.t("sessions.we_will_lock_account"))
          end

          it "locks account after three failed attempts" do
            user.update!(failed_logins_count: 2)

            session = described_class.new(handle: handle, password: "gibberish_password")

            expect(session.save).to be_falsey
            expect(session.errors.full_messages).to include(I18n.t("sessions.we_locked_account"))
          end
        end
      end
    end
  end
end
