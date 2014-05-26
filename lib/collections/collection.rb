# require dependencies
require 'active_record'
require 'active_support/inflector'
require 'collections/helpers/name_convention_type'
require "collections/collection_proxy_adapter"
require "collections/has_many_adapter"
require "collections/has_one_adapter"
require "collections/collection_builder"
require "collections/through_collection_builder"

module Collections
  class Collection

    def initialize(model:, proxy:)
      @model = model
      @proxy = proxy
    end

    def apply(name:, type:, through: nil)
      @name = name
      @type = type
      @through = through
      
      through ? define_though_collection : define_collection
    end

    private
      attr_reader :model, :proxy
      attr_reader :name, :type, :through


      def define_collection
        CollectionBuilder.new(
          :model_class => model,
          :adapter => adapter,
          :collection => collection,
        ).apply(
          :name => name,
          :type => type
        )
      end

      def define_though_collection
        ThroughCollectionBuilder.new(
          :model_class => model,
          :adapter => adapter,
          :collection => collection,
        ).apply(
          :name => name,
          :type => type
        )
      end

      def collection
        @collection = CollectionProxyAdapter.new(
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
        collection_name_plural? ? HasManyAdapter : HasOneAdapter
      end

      def collection_name_plural?
        NameConventionType.new(name.to_s).plural?
      end

      def symbolize(word)
        word.to_s.downcase.to_sym
      end
  end
end
