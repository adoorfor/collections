require 'spec_helper'

RSpec.describe "setup requirements" do
  
  describe "active record models" do
    
    it 'lets us make a record' do
      expect {
        User.create(name: 'fish')
      }.to change {User.count }.from(0).to(1)
    end

    it 'we can remove records' do
      User.create(name: 'fish')
      expect {
        User.destroy_all
      }.to change {User.count }.from(1).to(0)
    end
  end

end
