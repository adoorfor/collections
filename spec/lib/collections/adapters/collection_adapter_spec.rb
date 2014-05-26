require 'spec_helper'

RSpec.describe Collections::CollectionAdapter do


  describe "given that there is a Collection Model within the Object Constant" do

    class ApplePear; end

    let(:adapter) {
      Collections::CollectionAdapter.new(primary: 'user', secondary: 'fish')
    }

    it "will return the ApplePears class object" do
      expect(
        adapter.apply("ApplePear")
      ).to eq(ApplePear)
    end 
  end


  describe "given that there is no collection Model within the Object Constant" do

    let(:adapter) {
      Collections::CollectionAdapter.new(primary: 'bear', secondary: 'cat')
    }

    it "will return the PearApple class object" do
      expect(
        adapter.apply("PearApple")
      ).to eq(PearApple)
    end

    it "will add the active_record belongs to methods for the primary and secondary arguments" do
      adapter.apply("BearCat")
      bear_cat_collection = BearCat.new

      expect(bear_cat_collection.methods).to include(:cat)
      expect(bear_cat_collection.methods).to include(:bear)
    end 
  end
end
