module Collections
  class NameConventionType

    def initialize(word)
      @word = word
    end

    def plural?
      return false unless pluralized?
      true
    end

    private
      attr_reader :word

      def pluralized?
        word.to_s == word.to_s.pluralize
      end
  end
end
