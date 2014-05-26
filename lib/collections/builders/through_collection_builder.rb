module Collections
  class ThroughCollectionBuilder
    
    def initialize(model_class:, collection:, adapter:)
      @collection = collection
      @adapter = adapter.new(model: model_class)
      @model_class = model_class
    end

    def apply(name:, type:)
      @name = name
      @type = type
      define_collection(
        collection: collection,
      )
    end

    private
      attr_reader :adapter, :model_class
      attr_reader :name, :collection, :type

      def define_collection(collection:)
        pass_though_collection(
          collection: collection,
        )

        adapter.apply(
          name,
          :through => :"#{collection.name.underscore}_#{name}",
          :source => type,
        )
      end

      def pass_though_collection(collection:)
        adapter.apply(
          :"#{collection.name.underscore}_#{name}",
          role_query(role),
          :class_name => collection.name,
          :foreign_key => model_class.name.foreign_key.to_sym,
        )
      end

      def role_query(query_value)
        Proc.new { where(role: query_value) }
      end

      def role
        name.to_s.downcase.underscore.singularize
      end
  end
end
