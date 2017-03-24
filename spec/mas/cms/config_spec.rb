RSpec.describe Mas::Cms::Config do
  subject(:config)   { Mas::Cms::Config.new }
  let(:timeout)      { 10 }
  let(:open_timeout) { 10 }
  let(:retries)      { 2 }
  let(:host)         { 'http://localhost:4000' }
  let(:api_token)    { 'token' }

  before do
    config.timeout      = timeout
    config.open_timeout = open_timeout
    config.host         = host
    config.api_token    = api_token
    config.retries      = retries
  end

  [:timeout, :open_timeout, :host, :api_token, :retries].each do |attr|
    it "responds to `#{attr}`" do
      expect(config.send(attr)).to eq self.send(attr)
    end
  end
end
