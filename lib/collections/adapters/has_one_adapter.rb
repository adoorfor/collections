module Collections
  class HasOneAdapter

    def initialize(model:)
      @model = model
    end

    def apply(name, *arguments)
      model.instance_eval do
        has_one(name, *arguments)
      end
    end

    private
      attr_reader :model
  end
end
