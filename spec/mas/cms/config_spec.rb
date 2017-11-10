RSpec.describe Mas::Cms::Config do
  subject(:config)   { Mas::Cms::Config.new }
  let(:timeout)      { 10 }
  let(:open_timeout) { 10 }
  let(:retries)      { 2 }
  let(:host)         { 'http://localhost:4000' }
  let(:api_token)    { 'token' }
  let(:cache)        { double(:cache) }
  let(:cache_gets)   { false }

  before do
    config.timeout      = timeout
    config.open_timeout = open_timeout
    config.host         = host
    config.api_token    = api_token
    config.retries      = retries
    config.cache        = cache
    config.cache_gets   = cache_gets
  end

  %i[timeout open_timeout host api_token retries cache cache_gets].each do |attr|
    it "responds to `#{attr}`" do
      expect(config.send(attr)).to eq send(attr)
    end
  end
end
