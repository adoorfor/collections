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
      member = organisation.members.create(
        name: 'Father Peter',
      )

      expect(
        organisation.reload.admins
      ).to_not include(member)
    end

    it "returns the admin within the member collection" do
      member = organisation.members.create(
        name: 'Father Member',
      )

      admin = organisation.admins.create(
        name: 'Father Peter',
      )
      expect(
        organisation.reload.members
      ).to include(admin)
    end
  end


  describe "Organisation relationship to the Owner" do


    it "returns a single record for the owner and not a collection proxy" do
      member = organisation.members.create(
        name: 'Father Member',
      )

      owner = User.create(
        name: 'Father Peter',
      )

      organisation.owner = owner
      organisation.save

      expect(
        organisation.reload.owner
      ).to eq(owner)
    end

    it "The Organisation can create a owner, but that owner is not an admin" do
      member = organisation.members.create(
        name: 'Father Member',
      )

      owner = User.create(
        name: 'Father Peter',
      )

      organisation.owner = owner
      organisation.save

      expect(
        organisation.reload.admins
      ).to_not include(owner)
    end

    it "returns the owner within the member collection" do
      owner = User.create(
        name: 'Father Peter',
      )
      organisation.owner = owner
      organisation.save

      expect(
        organisation.reload.members
      ).to include(owner)
    end

  end
end
