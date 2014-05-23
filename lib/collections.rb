# require dependencies
require 'active_record'
require 'active_support'


require "collections/version"
require "collections/collection_proxy_adapter"

module Collections
  extend ActiveSupport::Concern
  
  module ClassMethods
    def collection(name:, as:, through: nil, role: nil, proxy: false)
      collection = collection_relational_class(
        collection_name(name, through),
        self.name.to_s,
        as.to_s,
      )

      through ? define_collection_proxy(name, collection, as) : define_collection(name, collection, as)
      
      has_many(
        name,
        :through => :"#{collection.name.underscore}_#{name}",
        :source => as,
      )
    end

    private
      def define_collection(name, collection, as)
        has_many(
          :"#{collection.name.underscore}_#{name}",
          :class_name => collection.name,
          :foreign_key => self.name.to_s.foreign_key,
        )
      end

      def define_collection_proxy(name, collection, as)
        has_many(
          :"#{collection.name.underscore}_#{name}",
          -> { where(role: name.to_s.singularize) },
          :class_name => collection.name,
          :foreign_key => self.name.to_s.foreign_key,
        )
      end

      def collection_relational_class(collection_name, primary, secondary)
        klass = CollectionProxyAdapter.new(primary: primary, secondary: secondary)
        klass.apply(collection_name)
      end

      def collection_name(collection_name, through)
        secondary_name = through ? through.to_s.classify : collection_name.to_s.classify
        self.name.to_s + secondary_name
      end
  end
end

ActiveRecord::Base.extend(Collections)
