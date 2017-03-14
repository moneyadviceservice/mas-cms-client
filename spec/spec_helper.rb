$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'mas/cms/client'
require 'registry'

require 'webmock/rspec'
require 'shoulda-matchers'
require 'factory_girl'
require 'faker'
require 'vcr'

def config
  {
    timeout:   ( ENV['FRONTEND_HTTP_REQUEST_TIMEOUT'] ||= '10' ),
    api_token: ( ENV['MAS_CMS_API_TOKEN'] ||= 'mytoken' ),
    cms_url:   ( ENV['MAS_CMS_URL'] ||= 'http://localhost:3000' )
  }
end

puts "Test are running with this config: #{config.inspect}"

FactoryGirl.find_definitions

RSpec.configure do |c|
  c.alias_it_should_behave_like_to :it_has_behavior,
                                   'exhibits behaviour of an'
  c.include(Shoulda::Matchers::ActiveModel, type: :model)
  c.include FactoryGirl::Syntax::Methods
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock

  c.around_http_request do |request|
    uri = URI(request.uri)
    VCR.use_cassette("/CMS/#{request.method}#{uri.path}#{uri.query}", &request)
  end
end

Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }
