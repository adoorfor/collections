require 'spec_helper'

RSpec.describe User do

  let(:user) { User.create(name: "Father Jack") }
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
end
