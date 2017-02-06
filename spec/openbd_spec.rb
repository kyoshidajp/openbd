require 'spec_helper'

describe Openbd do
  before do
    # single ISBN when get method
    stub_request(:get, %r{^#{Openbd::END_POINT}/get\?[^,]+$})
      .to_return(body: File.new('spec/files/get_single.json').read)

    # multi ISBN when get method
    stub_request(:get, %r{^#{Openbd::END_POINT}\/get\?.+,.+$})
      .to_return(body: File.new('spec/files/get_multi.json').read)

    # single ISBN when post method
    stub_request(:post, %r{^#{Openbd::END_POINT}\/get$})
      .with(body: { isbn: /[^,]+/ })
      .to_return(body: File.new('spec/files/get_single.json').read)

    # multi ISBN when post method
    stub_request(:post, %r{^#{Openbd::END_POINT}\/get$})
      .with(body: { isbn: /.+,.+/ })
      .to_return(body: File.new('spec/files/get_multi.json').read)

    # coverage
    stub_request(:get, %r{^#{Openbd::END_POINT}\/coverage$})
      .to_return(body: File.new('spec/files/coverage.json').read)
  end

  let(:client) { Openbd::Client.new }

  it 'has a version number' do
    expect(Openbd::VERSION).not_to be nil
  end

  shared_examples_for 'items' do
    it 'return onix items' do
      expect(book.keys).to include 'onix'
    end

    it 'return hanmoto items' do
      expect(book.keys).to include 'hanmoto'
    end

    it 'return summary items' do
      expect(book.keys).to include 'summary'
    end
  end

  describe '.get' do
    context 'single ISBN' do
      let(:response) { client.get('978-4-7808-0204-7') }
      let(:book) { response[0] }

      it 'return single book data' do
        expect(response.size).to eq 1
      end

      it_should_behave_like 'items'
    end

    context 'multi ISBN' do
      let(:response) { client.get('4-06-2630869,978-4-06-2144490') }

      it 'return single book data' do
        expect(response.size).to eq 2
      end

      it_should_behave_like 'items' do
        let(:book) { response[0] }
      end

      it_should_behave_like 'items' do
        let(:book) { response[1] }
      end
    end
  end

  describe '.get_big' do
    context 'single ISBN' do
      let(:response) { client.get_big('978-4-7808-0204-7') }
      let(:book) { response[0] }

      it 'return single book data' do
        expect(response.size).to eq 1
      end

      it_should_behave_like 'items'
    end

    context 'multi ISBN' do
      let(:response) { client.get('4-06-2630869,978-4-06-2144490') }

      it 'return single book data' do
        expect(response.size).to eq 2
      end

      it_should_behave_like 'items' do
        let(:book) { response[0] }
      end

      it_should_behave_like 'items' do
        let(:book) { response[1] }
      end
    end
  end

  describe '.coverage' do
    let(:response) { client.coverage }

    it 'return onix items' do
      expect(response).to be_a_kind_of(Array)
    end
  end
end
