require './lib/collections/collection'


RSpec.describe Collections::Collection do

  let(:model) {
    double(
      'active record model',
      :name => 'Example',
    )
  }
  
  let(:collection_object) {
    Collections::Collection.new(
      model: model,
    )
  }

  let(:collection_proxy_object) {
    double(
      'collection proxy object',
      :apply => collection,
    )
  }

  let(:collection) {
    double(
      'collection'
    )
  }

  let(:builder) {
    double(
      'collection builder',
      :apply => true,
    )
  }

  before do
    Collections::CollectionProxyAdapter.stub(:new) { collection_proxy_object }
    Collections::CollectionBuilder.stub(:new) { builder }
    Collections::ThroughCollectionBuilder.stub(:new) { builder }   
  end

  describe "when given arguments for a plural named collection" do


    describe "when there is no :through argument" do

      it "asks the collection proxy adapter to define a collection proxy class object" do
        collection_object.apply(
          :name => :members,
          :type => :user
        )

        expect(Collections::CollectionProxyAdapter)
          .to have_received(:new)
          .with(
            :primary => :example,
            :secondary => :user,
          ).once
      end

      it 'applies the collection name to the collection proxy object class, to define the collection proxy object' do
        collection_object.apply(
          :name => :members,
          :type => :user
        )

        expect(collection_proxy_object)
          .to have_received(:apply)
          .with('ExampleMember')
          .once
      end


      it "defines the collection builder on the given model with the collection and adapter required" do
        collection_object.apply(
          :name => :members,
          :type => :user
        )

        expect(Collections::CollectionBuilder)
          .to have_received(:new)
          .with(
            :model_class => model,
            :adapter => Collections::HasManyAdapter,
            :collection => collection,
          )
          .once
      end

      it "applies the name and type to the builder object to create the collection" do
        collection_object.apply(
          :name => :members,
          :type => :user
        )

        expect(builder)
          .to have_received(:apply)
          .with(
            :name => :members,
            :type => :user,
          )
      end
    end

    describe "when the arguments also include a :through argument" do

      it "asks the collection proxy adapter to define a collection proxy class object" do
        collection_object.apply(
          :name => :admins,
          :type => :user,
          :through => :members,
        )

        expect(Collections::CollectionProxyAdapter)
          .to have_received(:new)
          .with(
            :primary => :example,
            :secondary => :user,
          ).once
      end

      it 'applies the collection name to the collection proxy object class, to define the collection proxy object' do
        collection_object.apply(
          :name => :admins,
          :type => :user,
          :through => :members,
        )

        expect(collection_proxy_object)
          .to have_received(:apply)
          .with('ExampleMember')
          .once
      end


      it "defines the collection builder on the given model with the collection and adapter required" do
        collection_object.apply(
          :name => :admins,
          :type => :user,
          :through => :members,
        )

        expect(Collections::ThroughCollectionBuilder)
          .to have_received(:new)
          .with(
            :model_class => model,
            :adapter => Collections::HasManyAdapter,
            :collection => collection,
          )
          .once
      end

      it "applies the name and type to the builder object to create the collection" do
        collection_object.apply(
          :name => :admins,
          :type => :user,
          :through => :members,
        )

        expect(builder)
          .to have_received(:apply)
          .with(
            :name => :admins,
            :type => :user,
          )
      end
    end
  end

  describe "when given arguments for a non-plural named collection" do


    describe "when there is no :through argument" do
    end

    describe "when the arguments also include a :through argument" do
    end
  end
end
