require 'openbd/version'
require 'httpclient'
require 'multi_json'

module Openbd

  END_POINT = 'https://api.openbd.jp/v1'

  class Client

    def get(isbn)
      _get(isbn, :get)
    end

    def get_big(isbn)
      _get(isbn, :post)
    end

    def coverage
      url = "#{END_POINT}/coverage"
      resp = client.get(url)
      body(resp)
    end

    private

    def client
      @client ||= HTTPClient.new
    end

    def body(resp)
      MultiJson.load(resp.body)
    end

    def _get(isbn, method)
      return unless [:get, :post].include?(method)

      url = "#{END_POINT}/get"
      q = { isbn: isbn }
      resp = client.send(method, url, q)
      body(resp)
    end
  end
end
