# Openbd

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

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

