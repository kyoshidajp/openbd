require 'openbd/version'
require 'httpclient'
require 'json'

module Openbd

  class RequestError < StandardError; end

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
      JSON.parse(resp.body)
    end

    def _get(isbn, method)
      return unless [:get, :post].include?(method)

      url = "#{END_POINT}/get"
      q = { isbn: isbn_param(isbn) }
      resp = client.send(method, url, q)
      body(resp)
    end

    def isbn_param(value)
      isbns = if value.instance_of?(String)
                value.split(',')
              elsif value.instance_of?(Array)
                value
              else
                raise Openbd::RequestError,
                      "Invalid type of param: #{value.class}(#{value})"
              end
      isbns.join(',')
    end
  end
end
