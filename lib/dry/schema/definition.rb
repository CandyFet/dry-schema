require 'dry/initializer'

require 'dry/schema/config'
require 'dry/schema/result'
require 'dry/schema/messages'
require 'dry/schema/message_compiler'

module Dry
  module Schema
    class Definition
      extend Dry::Initializer

      param :rules

      option :input_rules, optional: true, default: proc { nil }

      option :config, default: proc { Config.new }

      option :message_compiler, default: proc { MessageCompiler.new(Messages.setup(config)) }

      def call(input)
        results = rules.reduce([]) { |a, (name, rule)|
          unless input.error?(name)
            result = rule.(input)
            a << result unless result.success?
          end
          a
        } || EMPTY_ARRAY

        input.concat(results)
      end

      def to_ast
        [:set, rules.values.map(&:to_ast)]
      end

      # required by Dry::Logic::Rule interface
      def ast(input)
        to_ast
      end

      def to_rule
        self
      end
    end
  end
end
