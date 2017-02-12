require 'httpclient'
require 'json'

module Openbd

  # Raised for request error.
  class RequestError < StandardError; end

  # Raised for response error.
  class ResponseError < StandardError; end

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
    # @raise [ResponseError] if the response is wrong
    # @return [Hash] Biblio infomation
    def get(isbn)
      url = "#{end_point}/get"
      isbns = isbn_param(isbn)
      method = get_method(isbns)
      q = { isbn: isbns.join(',') }
      resp = httpclient.send(method, url, q)
      body(resp)
    end

    # call /coverage
    #
    # @raise [ResponseError] if the response is wrong
    # @return [Array<String>] List of ISBN
    def coverage
      url = "#{end_point}/coverage"
      resp = httpclient.get(url)
      body(resp)
    end

    # call /schema
    #
    # @raise [ResponseError] if the response is wrong
    def schema
      url ="#{end_point}/schema"
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
    
    def end_point
      END_POINT
    end

    def body(resp)
      return JSON.parse(resp.body) if resp.ok?

      raise Openbd::ResponseError, "#{resp.status}\n#{resp.content}"
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
