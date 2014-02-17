require 'spec_helper'
require 'core/repositories/api'

module Core::Repositories
  describe API do
    let(:url) { 'https://example.com/path/to/url' }
    let(:type) { 'article' }

    describe '#find' do
      subject(:repository) { described_class.new(url, type) }

      let(:id) { 'beginners-guide-to-managing-your-money' }

      context 'when the type exists' do
        before do
          stub_request(:get, 'https://example.com/en/articles/beginners-guide-to-managing-your-money.json').
            to_return(status: 200, body: body, headers: {})
        end

        let(:body) { File.read('spec/fixtures/%s.json' % id) }

        it 'returns a hash of attributes' do
          expect(repository.find(id)).to be_a(Hash)
          expect(repository.find(id)["id"]).to eq(id)
        end
      end

      context 'when the type is non-existent' do
        before do
          stub_request(:get, 'https://example.com/en/articles/beginners-guide-to-managing-your-money.json').
            to_return(status: 404, body: nil, headers: {})
        end

        it 'returns nil' do
          expect(repository.find(id)).to be_nil
        end
      end

      context 'when there is a proxy authentication error' do
        before do
          stub_request(:get, 'https://example.com/en/articles/beginners-guide-to-managing-your-money.json').
            to_return(status: 407, body: nil, headers: {})
        end

        it 'raises an API::RequestError' do
          expect { repository.find(id) }.to raise_error(API::RequestError)
        end
      end

      context 'when there is an error' do
        before do
          stub_request(:get, 'https://example.com/en/articles/beginners-guide-to-managing-your-money.json').
            to_return(status: 500, body: nil, headers: {})
        end

        it 'raises an API::RequestError' do
          expect { repository.find(id) }.to raise_error(API::RequestError)
        end
      end
    end
  end
end
