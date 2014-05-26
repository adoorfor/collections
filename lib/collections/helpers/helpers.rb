require 'collections/helpers/name_convention_type'

module Collections
  module Helpers
    extend ActiveSupport::Concern

    def plural?(word)
      NameConventionType.new(word.to_s).plural?
    end

    def symbolize(word)
      word.to_s.underscore.to_sym
    end

    def singularize(word)
      word.to_s.downcase.underscore.singularize
    end
  end
end
