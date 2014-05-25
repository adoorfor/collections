require './lib/collections/collection_builder'

RSpec.describe CollectionBuilder do
  
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
      CollectionBuilder.new(
        model_class: model_class,
        adapter: adapter_class,
        collection: collection,
      )
    }

    it "defines the collection with the adapter" do

      expect(adapter)
        .to receive(:apply)
        .with(
          :organisation_member_members,
          :class_name => 'OrganisationMember',
          :foreign_key => :user_id,
        ).once.ordered


      expect(adapter)
        .to receive(:apply)
        .with(
          :members,
          :through => :organisation_member_members,
          :source => :user,
        ).once.ordered

      builder.apply(
        :name => :members,
        :type => :user,
      )
    end
  end
end
