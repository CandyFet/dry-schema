require 'dry/initializer'

module Dry
  module Schema
    class ValueCoercer
      extend Dry::Initializer

      param :type_schema

      def call(input)
        type_schema[Hash(input)]
      end
    end
  end
end
