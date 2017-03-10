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

  context 'validation' do
    context 'timeout' do
      let(:timeout) { 'banana :)' }
      it 'must resolve to a integer greater than 0' do
        expect(config).to be_invalid
      end
    end

  end
end
