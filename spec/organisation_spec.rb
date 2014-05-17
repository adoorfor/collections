require 'spec_helper'

RSpec.describe Organisation do

  # describe "Organisation's relationship owner" do
   
  #   let(:fred) { create(:user, name: 'Fred') }
  #   let(:zoheb) { create(:user, name: 'Zoheb') }
  #   let!(:organisation) { create(:organisation) }
    
  #   describe "when the organisation has an owner" do

  #     it "will not be able to have two owners" do
  #       organisation.owner = fred
  #       organisation.owner = zoheb
        
  #       expect(
  #         organisation.reload.members.length
  #       ).to eq(1)
  #     end

  #     it "when setting the owner it returns the last one set" do
  #       organisation.owner = fred
  #       organisation.owner = zoheb
        
  #       expect(
  #         organisation.reload.members.first
  #       ).to eq(zoheb)
  #     end

  #   end
  # end

  describe "Organisation's relationships to Members" do

    let(:member) { User.create(name: "Fred") }
    let(:organisation) { Organisation.create(name: "Example Club") }
    let!(:another_organisation) { Organisation.create(name: "Another Example Club") }

    it "The Organisation can create a member" do
      fred = organisation.members.create(
        name: 'Fred West',
      )
      expect(
        organisation.reload.members
      ).to include(fred)
    end

    it "The Organisation can create a member, but that member is not an admin" do
      fred = organisation.members.create(
        name: 'Fred West',
      )
      expect(
        organisation.reload.admins
      ).to_not include(fred)
    end

    # it "The Organisation can create a member, but that member is not the owner" do
    #   fred = organisation.members.create(
    #     name: 'Fred West',
    #   )
    #   expect(
    #     organisation.reload.owner
    #   ).to_not eq(fred)
    # end

    # it "The Organisation can create a member and the member belongs to the organisation" do
    #   fred = organisation.members.create(
    #     name: 'Fred West',
    #     email: 'Fred@west.com',
    #     password: "go fishing for a good password that nobody can find",
    #   )
    #   expect(
    #     fred.organisations
    #   ).to include(organisation)
    # end
  end
end
