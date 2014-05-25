# require dependencies
require 'active_record'
require "collections/collection"

module Collections
  extend ActiveSupport::Concern
  
  module ClassMethods
    def collection(name:, as:, through: nil, proxy: false)
      Collection.new(model: self)
        .apply(
          :name => name,
          :type => as,
          :through => through,
        )
    end
  end
end
