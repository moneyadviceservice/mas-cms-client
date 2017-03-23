RSpec.describe Mas::Cms::Connection do
  subject(:connection) { described_class.new }

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

    it 'builds a connection' do
      expect(Faraday).to receive(:new).with(options)
      Mas::Cms::Connection.new
    end
  end

  describe '.get' do
    let(:params) { '/test/me.json' }

    context 'when successful' do
      it 'delegates to raw_connection' do
        expect(connection.raw_connection).to receive(:get).with(params)
        connection.get(params)
      end
    end

    context 'when resource not found' do
      before do
        allow(connection.raw_connection)
          .to receive(:get)
          .with(params)
          .and_raise(Faraday::Error::ResourceNotFound, 'foo')
      end
      it 'raises an `Mas::Cms::Connection::ResourceNotFound error' do
        expect { connection.get(params) }.to raise_error(Mas::Cms::Connection::ResourceNotFound)
      end
    end

    context 'when connection failed' do
      before do
        allow(connection.raw_connection)
          .to receive(:get)
          .with(params)
          .and_raise(Faraday::Error::ConnectionFailed, 'foo')
      end
      it 'raises an `Mas::Cms::Connection::ConnectionFailed error' do
        expect { connection.get(params) }.to raise_error(Mas::Cms::Connection::ConnectionFailed)
      end
    end

    context 'when client error' do
      before do
        allow(connection.raw_connection)
          .to receive(:get)
          .with(params)
          .and_raise(Faraday::Error::ClientError, 'foo')
      end
      it 'raises an `Mas::Cms::Connection::ClientError error' do
        expect { connection.get(params) }.to raise_error(Mas::Cms::Connection::ClientError)
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
        expect { connection.post(params) }.to raise_error(Mas::Cms::Connection::ConnectionFailed)
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
        expect { connection.post(params) }.to raise_error(Mas::Cms::Connection::ClientError)
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
        expect { connection.post(params) }.to raise_error(Mas::Cms::Connection::UnprocessableEntity)
      end
    end
  end
end
