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

# coverage
client.coverage
```

Set `HTTP_SERVER` or `http_server` as Environment Variable if you'd like to access via proxy server.

```
export HTTP_PROXY=http://user:pass@host:port
# or
export http_proxy=http://user:pass@host:port
```

## Requirements

- Ruby(MRI) 2.3.0 or higher

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

