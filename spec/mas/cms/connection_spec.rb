RSpec.describe Mas::Cms::Connection do
  subject(:connection) { described_class.new(cache) }
  let(:cache) { spy(:cache) }

  describe '.new' do
    let(:config) { Mas::Cms::Client.config }
    let(:options) do
      {
        url: config.host,
        request: {
          timeout: config.timeout,
          open_timeout: config.open_timeout
        }
      }
    end

    before { allow(Faraday).to receive(:new).with(options) }

    it 'builds a connection' do
      expect(Faraday).to receive(:new).with(options)
      Mas::Cms::Connection.new
    end

    it 'accepts a cache object' do
      conn = Mas::Cms::Connection.new(cache)
      expect(conn.cache).to eq(cache)
    end
  end

  describe '.get' do
    let(:path)     { '/test/me.json' }
    let(:response) { double(status: status, headers: {}, body: {}) }
    let(:status)   { 200 }

    context 'when sending params' do
      let(:params) { { document_type: 'Insight' } }

      it 'delegates to raw_connection with params' do
        expect(connection.raw_connection).to receive(:get).with(
          path,
          params
        ).and_return(response)
        connection.get(path, params: params, cached: false)
      end
    end

    context 'when successful and not cached' do
      it 'delegates to raw_connection' do
        expect(connection.raw_connection).to receive(:get).with(path, nil).and_return(response)
        connection.get(path, cached: false)
      end
    end

    context 'when successful and cached' do
      it 'calls cache object' do
        expect(connection.cache).to receive(:fetch).and_return(response)
        connection.get(path, cached: true)
      end
    end

    context 'when response is a redirection' do
      before { allow(connection.raw_connection).to receive(:get).and_return(response) }
      let(:status) { 301 }
      it 'raises a `HttpRedirect` instance for http 301 status' do
        expect { connection.get(path) }.to raise_exception Mas::Cms::HttpRedirect
      end
    end

    context 'when response body is null' do
      let(:response) { double(status: status, headers: {}, body: nil) }
      before { allow(connection.raw_connection).to receive(:get).and_return(response) }

      it 'raises an `Mas::Cms::Connection::ResourceNotFound error' do
        expect { connection.get(path) }.to raise_error(Mas::Cms::Errors::ResourceNotFound)
      end
    end

    context 'when resource not found' do
      before do
        allow(connection.raw_connection)
          .to receive(:get)
          .with(path, nil)
          .and_raise(Faraday::Error::ResourceNotFound, 'foo')
      end

      it 'raises an `Mas::Cms::Connection::ResourceNotFound error' do
        expect { connection.get(path) }.to raise_error(Mas::Cms::Errors::ResourceNotFound)
      end
    end

    context 'when connection failed' do
      before do
        allow(connection.raw_connection)
          .to receive(:get)
          .with(path, nil)
          .and_raise(Faraday::Error::ConnectionFailed, 'foo')
      end
      it 'raises an `Mas::Cms::Connection::ConnectionFailed error' do
        expect { connection.get(path) }.to raise_error(Mas::Cms::Errors::ConnectionFailed)
      end
    end

    context 'when client error' do
      before do
        allow(connection.raw_connection)
          .to receive(:get)
          .with(path, nil)
          .and_raise(Faraday::Error::ClientError.new('foo', status: 500))
      end

      it 'raises an `Mas::Cms::Connection::ClientError error' do
        expect { connection.get(path) }.to raise_error(Mas::Cms::Errors::ClientError)
      end
    end
  end

  describe '.post' do
    let(:params) { '/test/me.json' }

    context 'when successfull' do
      it 'delegates to raw_connection' do
        expect(connection.raw_connection).to receive(:post).with(params)
        connection.post(params)
      end
    end

    context 'when connection failed' do
      before do
        allow(connection.raw_connection)
          .to receive(:post)
          .with(params)
          .and_raise(Faraday::Error::ConnectionFailed, 'foo')
      end
      it 'raises an `Mas::Cms::Connection::ConnectionFailed error' do
        expect { connection.post(params) }.to raise_error(Mas::Cms::Errors::ConnectionFailed)
      end
    end

    context 'when client error' do
      before do
        allow(connection.raw_connection)
          .to receive(:post)
          .with(params)
          .and_raise(Faraday::Error::ClientError.new('foo', status: 500))
      end
      it 'raises an `Mas::Cms::Connection::ClientError error' do
        expect { connection.post(params) }.to raise_error(Mas::Cms::Errors::ClientError)
      end
    end

    context 'when unprocessable entity' do
      before do
        allow(connection.raw_connection)
          .to receive(:post)
          .with(params)
          .and_raise(Faraday::Error::ClientError.new('foo', status: 422))
      end
      it 'raises an `Mas::Cms::Connection::UnprocessableEntity error' do
        expect { connection.post(params) }.to raise_error(Mas::Cms::Errors::UnprocessableEntity)
      end
    end
  end

  describe '.post' do
    let(:params) { '/test/me.json' }

    context 'when successfull' do
      it 'delegates to raw_connection' do
        expect(connection.raw_connection).to receive(:patch).with(params)
        connection.patch(params)
      end
    end

    context 'when unprocessable entity' do
      before do
        allow(connection.raw_connection)
          .to receive(:patch)
          .with(params)
          .and_raise(Faraday::Error::ClientError.new('foo', status: 422))
      end
      it 'raises an `Mas::Cms::Connection::UnprocessableEntity error' do
        expect { connection.patch(params) }.to raise_error(Mas::Cms::Errors::UnprocessableEntity)
      end
    end
  end
end
