require 'spec_helper'

RSpec.describe Organisation do

  let(:member) { User.create(name: "Father Jack") }
  let(:organisation) { Organisation.create(name: "The Church") }
  let!(:another_organisation) { Organisation.create(name: "DRINK") }

  describe "Organisation's relationships to Members" do

    it "The Organisation can create a member" do
      fred = organisation.members.create(
        name: 'Father Dougal',
      )
      expect(
        organisation.reload.members
      ).to include(fred)
    end

    it "allows for members to be added to the collection" do
      organisation.members << member

      expect(
        organisation.reload.members
      ).to include(member)
    end
  end

  describe "Organisation's relationships to Admin" do

    it "The Organisation can create a member, but that member is not an admin" do
      fred = organisation.members.create(
        name: 'Fred West',
      )
      expect(
        organisation.reload.admins
      ).to_not include(fred)
    end
  end
end
