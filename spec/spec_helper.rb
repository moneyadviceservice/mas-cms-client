$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'mas/cms/client'

ENV['FRONTEND_HTTP_REQUEST_TIMEOUT'] = '10'
ENV['MAS_CMS_API_TOKEN'] = 'mytoken'

RSpec.configure do |c|
  c.alias_it_should_behave_like_to :it_has_behavior,
                                   'exhibits behaviour of an'
end
