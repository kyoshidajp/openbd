# Openbd

[![Gem Version](https://badge.fury.io/rb/openbd.svg)](https://badge.fury.io/rb/openbd) [![Build Status](https://travis-ci.org/kyoshidajp/openbd.svg?branch=master)](https://travis-ci.org/kyoshidajp/openbd)

The Ruby library provides a wrapper to the [openBD API](https://openbd.jp/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'openbd'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install openbd

## Usage

Like this.

```rb
require 'openbd'

client = Openbd::Client.new

# get
client.get('978-4-7808-0204-7')
client.get('4-06-2630869,978-4-06-2144490')
client.get(['4-06-2630869', '978-4-06-2144490'])

# get less than 10,000 ISBNs 
isbns.size        # => 9,999
client.get(isbns)
# raise Error if over 10,000 ISBNs
isbns.size        # => 10,001
client.get(isbns) # => Param limit exceeded.

# coverage
client.coverage
```

You can ccess [HTTPClient](https://github.com/nahi/httpclient)([doc](http://www.rubydoc.info/gems/httpclient/HTTPClient)). For example:

```rb
client.httpclient.class # => HTTPClient
# set debug output device
client.httplicent.debug_dev = STDOUT
# set timeout param
client.connect_timeout = 100
client.send_timeout    = 100
client.receive_timeout = 100
```

## Using proxy

To access resources through HTTP proxy, following methods are available

1. Set Environment Variable
1. Set `HTTPClient#proxy=(proxy)`

### Set Environment Variable

Set `HTTP_SERVER` or `http_server` as Environment Variable.

```
export HTTP_PROXY=http://user:pass@host:port
# or
#export http_proxy=http://user:pass@host:port
```

### Set `HTTPClient#proxy=(proxy)`

`#httpclient` returns [HTTPClient](http://www.rubydoc.info/gems/httpclient/HTTPClient) instance. 

```rb
require 'openbd'

client = Openbd::Client.new
client.httpclient.class # => HTTPClient
client.httpclient.proxy = 'http://user:pass@host:port'
```

## Requirements

- Ruby(MRI) 2.2.0 or higher

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

