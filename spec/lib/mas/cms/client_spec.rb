RSpec.describe Mas::Cms::Client do
  subject(:client) { Mas::Cms::Client }

  describe '.config' do
    subject(:config) { Mas::Cms::Client.config }

    let(:timeout) { 10 }
    let(:host)    { 'http://localhost:4000' }

    before do
      client.config do |c|
        c.timeout = timeout
        c.host    = host
      end
    end

    it 'excepts block to setup config' do
      client.config do |c|
        expect(c).to be_a(Mas::Cms::Config)
      end
    end

    it 'returns timeout config' do
      expect(config.timeout).to eq timeout
    end

    it 'returns host config' do
      expect(config.host).to eq host
    end
  end
end
