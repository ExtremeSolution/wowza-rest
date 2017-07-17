require 'spec_helper'

RSpec.describe String do
  describe '#underscore' do
    context 'when given a camelCased word' do
      context 'when it has capital first letter' do
        it 'downcase the first letter' do
          word = 'CamelCased'.underscore
          expect(word).to eq('camel_cased')
        end
      end
      context 'when it contains hyphens' do
        it 'replaces all - with _' do
          word = 'camel-Cas-ed'.underscore
          expect(word).to eq('camel_cas_ed')
        end
      end
      context 'when its only one word' do
        it 'returns the downcased version of it' do
          word = 'Camel'.underscore
          expect(word).to eq('camel')
        end
      end
      it 'returns snake_cased version' do
        word = 'camelCased'.underscore
        expect(word).to eq('camel_cased')
      end
    end
  end
  describe '#camelize' do
    context 'when given a snake_cased word' do
      context 'when it has capital first letter ' do
        it 'returns downcase the first letter' do
          word = 'Snake_cased'.camelize
          expect(word).to eq('snakeCased')
        end
      end
      context 'when it starts with multiple capital letters' do
        it 'downcase all capital letters' do
          word = 'SNAKE_Cased'.camelize
          expect(word).to eq('snakeCased')
        end
      end
      context 'when it has hyphens' do
        it 'returns camelCased version' do
          word = 'snake-cased'.camelize
          expect(word).to eq('snakeCased')
        end
      end
      context 'when it contains a full capital letters word' do
        it 'returns all capital letters as is' do
          word = 'snake_CASED'.camelize
          expect(word).to eq('snakeCASED')
        end
      end
      it 'returns the camelCased version' do
        word = 'snake_cased'.camelize
        expect(word).to eq('snakeCased')
      end
    end
  end
end
