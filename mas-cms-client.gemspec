$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'mas/cms/client/version'

Gem::Specification.new do |spec|
  spec.name          = 'mas-cms-client'
  spec.version       = Mas::Cms::Client::VERSION
  spec.authors       = ['Money Advice Service']
  spec.email         = ['development.team@moneyadviceservice.org.uk']
  spec.description   = 'Library providing functionalities to interaction with MAS cms api'
  spec.summary       = 'MAS CMS client API gem.'
  spec.homepage      = 'https://www.moneyadviceservice.org.uk'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  warning = 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  raise warning unless spec.respond_to?(:metadata)

  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'activemodel', '>= 4.2'
  spec.add_runtime_dependency 'activesupport', '>= 4.2'
  spec.add_runtime_dependency 'faraday', '~> 0.9.2'
  spec.add_runtime_dependency 'faraday-conductivity', '~> 0.3.1'
  spec.add_runtime_dependency 'faraday_middleware', '~> 0.12.2'
  spec.add_runtime_dependency 'rubytree', '~> 0.9.7'
end
