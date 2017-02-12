require 'httpclient'
require 'json'

module Openbd

  # Raised for request error.
  class RequestError < StandardError; end

  END_POINT = 'https://api.openbd.jp/v1'

  # The Client class provides a wrapper to the openBD service
  #
  # @see https://openbd.jp/
  # @example
  #   require 'openbd'
  #
  #   client = Openbd::Client.new
  #
  #   # get
  #   client.get('978-4-7808-0204-7')
  class Client

    # call /get
    #
    # @param [String|Array] isbn ISBN
    # @raise [RequestError] if the request is wrong
    # @return [Hash] Biblio infomation
    def get(isbn)
      url = "#{END_POINT}/get"
      isbns = isbn_param(isbn)
      method = get_method(isbns)
      q = { isbn: isbns.join(',') }
      resp = httpclient.send(method, url, q)
      body(resp)
    end

    # call /coverage
    #
    # @return [Array<String>] List of ISBN
    def coverage
      url = "#{END_POINT}/coverage"
      resp = httpclient.get(url)
      body(resp)
    end

    # get HTTPClient
    #
    # @return [HTTPClient] HTTPClient
    def httpclient
      @httpclient ||= HTTPClient.new
    end

    private

    def body(resp)
      JSON.parse(resp.body)
    end

    def get_method(isbn_num)
      if isbn_num.size > 10_000
        raise Openbd::RequestError, 'Param limit exceeded.'
      end

      isbn_num.size > 1_000 ? :post : :get
    end

    def isbn_param(value)
      if value.instance_of?(String)
        value.split(',')
      elsif value.instance_of?(Array)
        value
      else
        raise Openbd::RequestError,
              "Invalid type of param: #{value.class}(#{value})"
      end
    end
  end
end
