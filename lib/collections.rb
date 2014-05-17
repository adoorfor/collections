# require dependencies
require 'active_record'
require 'active_support'


require "collections/version"

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
        klass = CollectionRelationProxyClass.new(primary: primary, secondary: secondary)
        klass.apply(collection_name)
      end

      def collection_name(collection_name, through)
        secondary_name = through ? through.to_s.classify : collection_name.to_s.classify
        self.name.to_s + secondary_name
      end
  end



  class HasManyRelationalCollectionProxy

    def initialize(type:, klass:)
      @type = type
      @klass = klass
    end

    def apply(name:)
      @name = name

      has_many(
        :"#{collection.name.underscore}_#{name}",
        :class_name => collection.name,
        :foreign_key => proxy_class_name.foreign_key,
      )
      
      has_many(
        name,
        :through => :"#{collection.name.underscore}_#{name}",
        :source => type,
      )
    end

    private
      attr_reader :type, :klass
      attr_reader :name

      def collection
        @collection ||= CollectionRelationProxyClass.new(
          primary: proxy_class_name,
          secondary: type,
        ).apply(collection_name)
      end

      def proxy_class_name
        klass.name.to_s
      end

      def collection_name
        proxy_class_name + name.classify
      end
  end

  class HasManyRelationalCollectionAssociatedProxy

    def initialize(type:, klass:)
      @type = type
      @klass = klass
    end

    def apply(name:)
      @name = name

      has_many(
        :"#{collection.name.underscore}_#{name}",
        :class_name => collection.name,
        :foreign_key => proxy_class_name.foreign_key,
      )
      
      has_many(
        name,
        :through => :"#{collection.name.underscore}_#{name}",
        :source => as,
      )
    end

    private
      attr_reader :type, :klass
      attr_reader :name

      def collection
        @collection ||= CollectionRelationProxyClass.new(
          primary: proxy_class_name,
          secondary: secondary,
        ).apply(collection_name)
      end

      def proxy_class_name
        klass.name.to_s
      end

      def collection_name
        proxy_class_name + name.classify
      end
  end

  class CollectionRelationProxyClass

    def initialize(primary:, secondary:)
      @primary = symbolize(primary)
      @secondary = symbolize(secondary)
    end

    def apply(collection_name)
      begin
        return collection_name.constantize 
      rescue NameError
        constuct_relation_class(collection_name)
        set_relations(primary, secondary)
        return collection_klass
      end
    end

    private
      attr_reader :primary, :secondary
      attr_reader :collection_klass

      def symbolize(argument)
        argument.underscore.to_sym
      end

      def set_relations(prime, second)
        collection_klass.class_eval {
          belongs_to prime
          belongs_to second
        }
      end

      def constuct_relation_class(name)
        @collection_klass = Object.const_set(
          name,
          Class.new(ActiveRecord::Base)
        )
      end
  end
end

ActiveRecord::Base.extend(Collections)
