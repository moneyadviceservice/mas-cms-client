module Mas::Cms::Repository::StaticPages
  RSpec.describe Cms do
    let(:url) { 'https://example.com/path/to/url' }

    describe '#find' do
      subject(:repository) { described_class.new }

      let(:id) { 'privacy' }
      let(:headers) { {} }

      before do
        allow(Mas::Cms::Registry::Connection).to receive(:[]).with(:cms) do
          Mas::Cms::ConnectionFactory::Http.build(url)
        end

        stub_request(:get, "https://example.com/api/en/corporate/#{id}.json")
          .to_return(status: status, body: body, headers: headers)
      end

      context 'when the type exists' do
        let(:body) { File.read('spec/fixtures/%s.json' % id) }
        let(:status) { 200 }

        it 'returns a hash of attributes' do
          expect(repository.find(id)).to be_a(Hash)
          expect(repository.find(id)['id']).to eq(id)
        end
      end

      context 'when the type is non-existent' do
        let(:body) { nil }
        let(:status) { 404 }

        it 'returns nil' do
          expect(repository.find(id)).to be_nil
        end
      end

      context 'when there is a proxy authentication error' do
        let(:body) { nil }
        let(:status) { 407 }

        it 'raises an API::RequestError' do
          expect { repository.find(id) }.to raise_error(::Mas::Cms::Repository::Base::RequestError)
        end
      end

      context 'when there is an error' do
        let(:body) { nil }
        let(:status) { 500 }

        it 'raises an API::RequestError' do
          expect { repository.find(id) }.to raise_error(::Mas::Cms::Repository::Base::RequestError)
        end
      end
    end
  end
end
