module Collections
  class HasManyAdapter

    def initialize(model:)
      @model = model
    end

    def apply(name, *arguments)
      model.instance_eval do
        has_many(name, *arguments)
      end
    end

    private
      attr_reader :model
  end
end
