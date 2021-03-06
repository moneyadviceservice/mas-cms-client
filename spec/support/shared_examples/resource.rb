RSpec.shared_examples_for 'a cms resource entity' do
  it 'behaves as a resource' do
    expect(described_class.included_modules).to include(Mas::Cms::Resource)
  end

  describe '.find' do
    let(:response) { double('Response', body: {}) }
    let(:conn)     { spy(:http_connection, get: response) }
    let(:slug)     { 'test' }

    before do
      allow(Mas::Cms::Client).to receive(:connection).and_return(conn)
    end

    it 'uses to process response' do
      expect(conn).to receive(:get)
      described_class.find(slug)
    end
  end
end
