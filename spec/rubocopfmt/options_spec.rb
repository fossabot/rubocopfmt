require 'spec_helper'

module RuboCopFMT
  RSpec.describe Options do
    describe 'files option' do
      it 'reader/writer methods' do
        options = Options.new

        options.files = ['foo.rb']

        expect(options.files).to eq(['foo.rb'])
      end

      it 'defaults to empty Array' do
        options = Options.new

        expect(options.files).to eq([])
      end
    end

    describe 'diff option' do
      it 'reader/writer methods' do
        options = Options.new

        options.diff = true

        expect(options.diff).to eq(true)
      end

      it 'defaults to false' do
        options = Options.new

        expect(options.diff).to eq(false)
      end
    end

    describe 'list option' do
      it 'reader/writer methods' do
        options = Options.new

        options.list = true

        expect(options.list).to eq(true)
      end

      it 'defaults to false' do
        options = Options.new

        expect(options.list).to eq(false)
      end
    end

    describe 'write option' do
      it 'reader/writer methods' do
        options = Options.new

        options.write = true

        expect(options.write).to eq(true)
      end

      it 'defaults to false' do
        options = Options.new

        expect(options.write).to eq(false)
      end
    end
  end
end
