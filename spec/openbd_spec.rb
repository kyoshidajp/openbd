require 'spec_helper'

describe Openbd do
  before do

    class OpenbdFaker < Sinatra::Base
      get '/v1/get' do
        isbns = params[:isbn].split(',')
        halt 413 if isbns.size > 1_000
        json = isbns.size > 1 ? 'get_multi.json' : 'get_single.json'
        body(File.new("spec/files/#{json}").read)
      end

      post '/v1/get' do
        isbns = params[:isbn].split(',')
        halt 413 if isbns.size > 10_000
        body(File.new('spec/files/get_multi.json').read)
      end

      get '/v1/coverage' do
        body(File.new('spec/files/coverage.json').read)
      end

      get '/v1/schema' do
        body(File.new('spec/files/schema.json').read)
      end

      get '/v1/notfound/get' do
        status 404
        'Not found'
      end
    end

    stub_request(:any, %r{^#{Openbd::END_POINT}}).to_rack(OpenbdFaker)
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
    context 'with String param' do
      context 'of single ISBN' do
        let(:response) { client.get('978-4-7808-0204-7') }
        let(:book) { response[0] }

        it 'return single book data' do
          expect(response.size).to eq 1
        end

        it_should_behave_like 'items'
      end

      context 'of multi ISBN' do
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

    context 'with Array param' do
      context 'of single ISBN' do
        let(:response) { client.get(['978-4-7808-0204-7']) }
        let(:book) { response[0] }

        it 'return single book data' do
          expect(response.size).to eq 1
        end

        it_should_behave_like 'items'
      end

      context 'of multi ISBN' do
        let(:response) { client.get(%w(4-06-2630869 978-4-06-2144490)) }

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

    context 'with Fixnum param' do
      it 'raise param type error' do
        expect { client.get(9784780802047) }
          .to raise_error(Openbd::RequestError)
      end

      it 'raise param type error with message' do
        num_type = 9784780802047.class
        expect { client.get(9784780802047) }
          .to raise_error("Invalid type of param: #{num_type}(9784780802047)")
      end
    end

    context 'with 10,000 params' do
      let(:response) do
        isbn = (10_001..20_000).to_a.join(',')
        client.get(isbn)
      end
      it_should_behave_like 'items' do
        let(:book) { response[0] }
      end
    end

    context 'with 10,001 params' do
      let(:isbn) { (10_001..20_001).to_a.join(',') }
      it 'raise param limit exceeded error with message' do
        expect { client.get(isbn) }
          .to raise_error(Openbd::RequestError, 'Param limit exceeded.')
      end
    end

    context 'NG response' do
      let(:client) do
        c = Openbd::Client.new
        def c.end_point
          'https://api.openbd.jp/v1/notfound'
        end
        c
      end
      it 'raise Openbd::ResponseError with message' do
        expect { client.get('978-4-7808-0204-7') }
          .to raise_error(Openbd::ResponseError, /^404\nNot found$/)
      end
    end
  end

  describe '.coverage' do
    let(:response) { client.coverage }

    it 'return Array' do
      expect(response).to be_a_kind_of(Array)
    end

    it 'return String of Array' do
      expect(response.all?{|isbn| isbn.instance_of?(String) }).to be true
    end
  end

  describe '.schema' do
    let(:response) { client.schema }

    it 'return Hash' do
      expect(response).to be_a_kind_of(Hash)
    end

    it 'return $shcema data' do
      expect(response['$schema']).to eq 'http://json-schema.org/draft-04/schema#'
    end
  end
end
