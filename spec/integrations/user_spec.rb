require 'spec_helper'

RSpec.describe User do

  let(:user) { User.create(name: "Father Jack") }
  let(:another_user) { User.create(name: "Father Pete") }
  let(:organisation) { Organisation.create(name: "The Church") }
  let!(:another_organisation) { Organisation.create(name: "DRINK") }

  describe "Users relationship to organisation's through membership" do

    it "returns the organisations that the user is a member of" do
      organisation.members << user
      
      expect(
        user.reload.organisations
      ).to include(organisation)
    end
  end

  describe "User's relationship to organisations that she is the owner of" do

    it "returns the organisations that the user owns when asked" do
      organisation.owner = user
      organisation.save

      expect(
        user.reload.organisation_ownerships
      ).to include(organisation)
    end

    it "does not return organisations that the user does not own" do
      organisation.owner = user
      organisation.save

      another_organisation.owner = another_user
      another_user.save

      expect(
        user.reload.organisation_ownerships
      ).to_not include(another_organisation)
    end

    it "returns the owner of the organisation within the members of the organisation" do
      organisation.owner = user
      organisation.save

      expect(
        user.reload.organisations
      ).to include(organisation)
    end
  end
end
