require './lib/collections/collection'


RSpec.describe Collections::Collection do

  let(:model) {
    double(
      'active record model',
      :name => 'Organisation',
    )
  }
  
  let(:collection_object) {
    Collections::Collection.new(
      model: model,
      proxy: false,
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
    Collections::CollectionAdapter.stub(:new) { collection_proxy_object }
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

        expect(Collections::CollectionAdapter)
          .to have_received(:new)
          .with(
            :primary => :organisation,
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
          .with('OrganisationMember')
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

        expect(Collections::CollectionAdapter)
          .to have_received(:new)
          .with(
            :primary => :organisation,
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
          .with('OrganisationMember')
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

      it "asks the collection proxy adapter to define a collection proxy class object" do
        collection_object.apply(
          :name => :owner,
          :type => :user,
        )

        expect(Collections::CollectionAdapter)
          .to have_received(:new)
          .with(
            :primary => :organisation,
            :secondary => :user,
          ).once
      end

      it 'applies the collection name to the collection proxy object class, to define the collection proxy object' do
        collection_object.apply(
          :name => :owner,
          :type => :user,
        )

        expect(collection_proxy_object)
          .to have_received(:apply)
          .with('OrganisationOwner')
          .once
      end


      it "defines the collection builder on the given model with the collection and adapter required" do
        collection_object.apply(
          :name => :owner,
          :type => :user,
        )

        expect(Collections::CollectionBuilder)
          .to have_received(:new)
          .with(
            :model_class => model,
            :adapter => Collections::HasOneAdapter,
            :collection => collection,
          )
          .once
      end

      it "applies the name and type to the builder object to create the collection" do
        collection_object.apply(
          :name => :owner,
          :type => :user,
        )

        expect(builder)
          .to have_received(:apply)
          .with(
            :name => :owner,
            :type => :user,
          )
      end
    end

    describe "when the arguments also include a :through argument" do
      
      it "asks the collection proxy adapter to define a collection proxy class object" do
        collection_object.apply(
          :name => :owner,
          :type => :user,
          :through => :members,
        )

        expect(Collections::CollectionAdapter)
          .to have_received(:new)
          .with(
            :primary => :organisation,
            :secondary => :user,
          ).once
      end

      it 'applies the collection name to the collection proxy object class, to define the collection proxy object' do
        collection_object.apply(
          :name => :owner,
          :type => :user,
          :through => :members,
        )

        expect(collection_proxy_object)
          .to have_received(:apply)
          .with('OrganisationMember')
          .once
      end


      it "defines the collection builder on the given model with the collection and adapter required" do
        collection_object.apply(
          :name => :owner,
          :type => :user,
          :through => :members,
        )

        expect(Collections::ThroughCollectionBuilder)
          .to have_received(:new)
          .with(
            :model_class => model,
            :adapter => Collections::HasOneAdapter,
            :collection => collection,
          )
          .once
      end

      it "applies the name and type to the builder object to create the collection" do
        collection_object.apply(
          :name => :owner,
          :type => :user,
          :through => :members,
        )

        expect(builder)
          .to have_received(:apply)
          .with(
            :name => :owner,
            :type => :user,
          )
      end
    end
  end


  describe "when arguments are given for a plural named collection with a proxy association" do

    let(:model) {
      double(
        'active record model',
        :name => 'User',
      )
    }

    let(:collection_object) {
      Collections::Collection.new(
        model: model,
        proxy: true,
      )
    }

    describe "when the arguments also include a :through argument" do

      it "asks the collection proxy adapter to define a collection proxy class object" do
        collection_object.apply(
          :name => :organisations,
          :type => :organisation,
          :through => :members,
        )

        expect(Collections::CollectionAdapter)
          .to have_received(:new)
          .with(
            :primary => :user,
            :secondary => :organisation,
          ).once
      end

      it 'applies the collection name to the collection proxy object class, to define the collection proxy object' do
        collection_object.apply(
          :name => :organisations,
          :type => :organisation,
          :through => :members,
        )

        expect(collection_proxy_object)
          .to have_received(:apply)
          .with('OrganisationMember')
          .once
      end


      it "defines the collection builder on the given model with the collection and adapter required" do
        collection_object.apply(
          :name => :organisations,
          :type => :organisation,
          :through => :members,
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
          :name => :organisations,
          :type => :organisation,
          :through => :members,
        )

        expect(builder)
          .to have_received(:apply)
          .with(
            :name => :organisations,
            :type => :organisation,
          )
      end
    end
  end

  describe "when arguments are given for a plural named collection with a proxy association" do
  end
end
