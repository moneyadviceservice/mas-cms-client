$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'mas/cms/client'
require 'registry'

require 'webmock/rspec'
require 'shoulda-matchers'
require 'factory_girl'
require 'faker'

ENV['FRONTEND_HTTP_REQUEST_TIMEOUT'] = '10'
ENV['MAS_CMS_API_TOKEN'] = 'mytoken'

FactoryGirl.find_definitions

RSpec.configure do |c|
  c.alias_it_should_behave_like_to :it_has_behavior,
                                   'exhibits behaviour of an'
  c.include(Shoulda::Matchers::ActiveModel, type: :model)
  c.include FactoryGirl::Syntax::Methods
end

Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }
