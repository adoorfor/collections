# require dependencies
require 'active_record'
require 'active_support/inflector'
require 'collections/helpers/helpers'
require "collections/adapters/collection_adapter"
require "collections/adapters/has_many_adapter"
require "collections/adapters/has_one_adapter"
require "collections/builders/collection_builder"
require "collections/builders/role_collection_builder"

module Collections
  class Collection
    include Helpers

    def initialize(model:, proxy:, role: nil)
      @model = model
      @proxy = proxy
      @role = role
    end

    def apply(name:, type:, through: nil)
      @name = name
      @type = type
      @through = through
      
      proxy ? proxy_builder : builder
    end

    private
      attr_reader :model, :proxy, :role
      attr_reader :name, :type, :through

      def proxy_builder
        collection_builder
      end

      def builder
        relational? ? through_collection_builder : collection_builder
      end

      def relational?
        through or role
      end

      def collection_role
        role ? role : singularize(name).to_sym
      end

      def collection_builder
        CollectionBuilder.new(
          :model_class => model,
          :adapter => adapter,
          :collection => collection,
        ).apply(
          :name => name,
          :type => type
        )
      end

      def through_collection_builder
        RoleCollectionBuilder.new(
          :model_class => model,
          :adapter => adapter,
          :collection => collection,
        ).apply(
          :name => name,
          :type => type,
          :role => collection_role,
        )
      end

      def collection
        @collection = CollectionAdapter.new(
          primary: symbolize(model.name),
          secondary: type,
        ).apply(collection_name)
      end

      def collection_name
        primary_name + secondary_name
      end

      def primary_name
        proxy ? type.to_s.classify : model.name.to_s
      end

      def secondary_name
        through ? through.to_s.classify : name.to_s.classify
      end

      def adapter
        plural?(name) ? HasManyAdapter : HasOneAdapter
      end
  end
end
