# require dependencies
require 'active_record'
require "collections/collection"

module Collections
  extend ActiveSupport::Concern
  
  module ClassMethods
    def collection(name:, as:, through: nil, proxy: false, role: nil)
      Collection.new(model: self, proxy: proxy)
        .apply(
          :name => name,
          :type => as,
          :through => through,
        )
    end
  end
end
