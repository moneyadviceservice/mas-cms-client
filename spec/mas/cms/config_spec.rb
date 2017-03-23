RSpec.describe Mas::Cms::Config do
  subject(:config) { Mas::Cms::Config.new }
  let(:timeout)    { 10 }
  let(:host)       { 'http://localhost:4000' }

  before do
    config.timeout = timeout
    config.host    = host
  end

  it 'responds to `timeout`' do
    expect(config.timeout).to eq timeout
  end

  it 'responds to `host`' do
    expect(config.host).to eq host
  end
end
