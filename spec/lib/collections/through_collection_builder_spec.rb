require './lib/collections/through_collection_builder'

RSpec.describe Collections::ThroughCollectionBuilder do
  
  let(:model_class) {
    double(
      'ActiveRecord Model',
      :name => 'User',
      :has_many => true
    )
  }

  let(:adapter_class) {
    double(
      'collection proxy adapter class',
      :new => adapter
    )
  }

  let(:adapter) {
    double(
      'collection proxy adapter',
      :apply =>true,
    )
  }

  let(:collection) {
    double(
      'collection object',
      :name => "OrganisationMember",
    )
  }

  describe "given the host class we add the has_many collection" do

    let(:builder) {
      Collections::ThroughCollectionBuilder.new(
        model_class: model_class,
        adapter: adapter_class,
        collection: collection,
      )
    }

    it "defines the collection with the adapter" do

      expect(adapter)
        .to receive(:apply)
        .with(
          :organisation_member_admins,
          an_instance_of(Proc), # Don't like this, Got to talk to Sam about it.
          :class_name => 'OrganisationMember',
          :foreign_key => :user_id,
        ).once.ordered


      expect(adapter)
        .to receive(:apply)
        .with(
          :admins,
          :through => :organisation_member_admins,
          :source => :user,
        ).once.ordered

      builder.apply(
        :name => :admins,
        :type => :user,
      )
    end
  end
end
