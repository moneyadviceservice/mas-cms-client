# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mas/cms/client/version'

Gem::Specification.new do |spec|
  spec.name          = "mas-cms-client"
  spec.version       = Mas::Cms::Client::VERSION
  spec.authors       = ['Money Advice Service']
  spec.email         = ['development.team@moneyadviceservice.org.uk']

  spec.summary       = %q{MAS CMS client API gem.}
  spec.homepage      = 'https://www.moneyadviceservice.org.uk'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'faraday', '~> 0.9.2'
  spec.add_runtime_dependency 'faraday-conductivity', '~> 0.3.1'
  spec.add_runtime_dependency 'faraday_middleware', '~> 0.10.0'
  spec.add_runtime_dependency 'activemodel', '~> 4.2.7'
  spec.add_runtime_dependency 'activesupport', '~> 4.2.7'
  spec.add_runtime_dependency 'rubytree', '~> 0.9.7'

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'webmock', '~> 2.1'
  spec.add_development_dependency 'shoulda-matchers', '~> 3.1'
  spec.add_development_dependency 'factory_girl', '~> 4.7'
  spec.add_development_dependency 'faker', '~> 1.6'
  spec.add_development_dependency 'vcr', '~> 3.0.3'
end