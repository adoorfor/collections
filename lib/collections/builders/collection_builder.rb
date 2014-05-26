module Collections
  class CollectionBuilder
    
    def initialize(model_class:, collection:, adapter:)
      @collection = collection
      @adapter = adapter
      @model_class = model_class
    end

    def apply(name:, type:)
      @name = name
      @type = type
      define_collection(
        model: model_class,
        collection: collection,
      )
    end


    private
      attr_reader :adapter, :model_class
      attr_reader :name, :collection, :type

      def define_collection(model:, collection:)
        define_though_collection(
          model: model,
          collection: collection,
        )
        adapter.new(model: model_class).apply(
          name,
          :through => :"#{collection.name.underscore}_#{name}",
          :source => type,
        )
      end

      def define_though_collection(model:, collection:)
        adapter.new(model: model_class).apply(
          :"#{collection.name.underscore}_#{name}",
          :class_name => collection.name,
          :foreign_key => model.name.foreign_key.to_sym,
        )
      end
  end
end
