RSpec.describe Mas::Cms::ConnectionFactory::Http, '.build' do
  subject(:factory) { described_class.build('http://example.com') }

  it "manufactures a `Mas::Cms::Connection::Http'" do
    expect(factory).to be_a(Mas::Cms::Connection::Http)
  end

  it 'has a timeout between 5 and 12 seconds' do
    expect(factory.options[:timeout]).to be_within(5).of(12)
  end

  it 'has a open timeout between 5 and 12 seconds' do
    expect(factory.options[:open_timeout]).to be_within(5).of(12)
  end

  it 'defaults to encoding JSON requests' do
    expect(factory.builder.handlers).to include(FaradayMiddleware::EncodeJson)
  end

  it 'defaults to retrying failed requests' do
    expect(factory.builder.handlers).to include(Faraday::Request::Retry)
  end

  it 'defaults to parsing JSON responses' do
    expect(factory.builder.handlers).to include(FaradayMiddleware::ParseJson)
  end

  it 'defaults to raising an error on failed responses' do
    expect(factory.builder.handlers).to include(Faraday::Response::RaiseError)
  end

  it 'includes instrumentation' do
    expect(factory.builder.handlers).to include(FaradayMiddleware::Instrumentation)
  end

  it 'uses Faraday::Adapter::NetHttp by default' do
    expect(factory.builder.handlers).to include(Faraday::Adapter::NetHttp)
  end
end
