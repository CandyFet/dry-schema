RSpec.describe Dry::Schema, 'pre-coercion input rules' do
  context 'with required key and filled' do
    subject(:schema) do
      Dry::Schema.define do
        required(:age).filter(format?: /\d+/).filled(:int, gt?: 18)
        required(:login).maybe(size?: 2..12)
      end
    end

    it 'uses pre-coercion rules' do
      expect(schema.call(age: 'foo', login: 'jane').errors)
        .to include(age: ['is in invalid format'])
    end

    it 'merges results' do
      expect(schema.call(age: 'foo', login: 'j').errors)
        .to eql(age: ['is in invalid format'], login: ['length must be within 2 - 12'])
    end
  end

  context 'with required key and maybe' do
    subject(:schema) do
      Dry::Schema.define do
        required(:age).filter(format?: /\d+/).maybe(:int, gt?: 18)
      end
    end

    it 'uses pre-coercion rules' do
      expect(schema.call(age: 'foo').errors).to eql(age: ['is in invalid format'])
    end
  end

  context 'with optional keys' do
    subject(:schema) do
      Dry::Schema.define do
        optional(:age).filter(format?: /\d+/).filled(:int, gt?: 18)
      end
    end

    it 'uses pre-coercion rules' do
      expect(schema.call(age: 'foo').errors).to eql(age: ['is in invalid format'])
    end

    it 'skips pre-coercion when key is missing' do
      expect(schema.call({}).errors).to be_empty
    end
  end
end
