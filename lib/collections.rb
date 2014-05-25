# require dependencies
require 'active_record'
require 'active_support'
require "collections/version"
require "collections/collection_proxy_adapter"
require "collections/has_many_adapter"
require "collections/collection_builder"
require "collections/through_collection_builder"

module Collections
  extend ActiveSupport::Concern
  
  module ClassMethods
    def collection(name:, as:, through: nil, role: nil, proxy: false)
      collection = collection_relational_class(
        collection_name(name, through),
        self.name.to_s,
        as.to_s,
      )

      through ? define_though_collection(name, collection, as) : define_collection(name, collection, as)
    end

    private
      def define_collection(name, collection, type)
        CollectionBuilder.new(
          :model_class => self,
          :adapter => has_many_adapter,
          :collection => collection,
        ).apply(
          :name => name,
          :type => type
        )
      end

      def define_though_collection(name, collection, type)
        ThroughCollectionBuilder.new(
          :model_class => self,
          :adapter => has_many_adapter,
          :collection => collection,
        ).apply(
          :name => name,
          :type => type
        )
      end

      def collection_relational_class(collection_name, primary, secondary)
        @klass = CollectionProxyAdapter.new(
          primary: primary,
          secondary: secondary
        ).apply(collection_name)
      end

      def collection_name(collection_name, through)
        secondary_name = through ? through.to_s.classify : collection_name.to_s.classify
        self.name.to_s + secondary_name
      end

      def has_many_adapter
        HasManyAdapter
      end
  end
end
