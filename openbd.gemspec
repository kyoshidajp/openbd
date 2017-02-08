lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'openbd/version'

Gem::Specification.new do |spec|
  spec.name          = 'openbd'
  spec.version       = Openbd::VERSION
  spec.authors       = ['kyoshidajp']
  spec.email         = ['claddvd@gmail.com']

  spec.summary       = 'openBD API'
  spec.description   = 'The library provides a wrapper to the openBD API'
  spec.homepage      = 'http://github.com/kyoshidajp/openbd'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 2.2.0'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'webmock', '~> 2.3.0'
  spec.add_runtime_dependency 'httpclient', '~> 2.8.3'
end
