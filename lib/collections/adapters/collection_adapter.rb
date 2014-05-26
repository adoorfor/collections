module Collections
    
  class CollectionAdapter
    include Helpers

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
