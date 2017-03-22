RSpec.shared_examples_for 'a cms page entity' do
  it 'behaves as a resource' do
    expect(described_class.included_modules).to include(Mas::Cms::Resource)
  end

  describe '.find' do
    let(:response) { double }
    let(:conn) { spy(:http_connection, get: double(body: {})) }

    before do
      allow(Mas::Cms::Client).to receive(:connection).and_return(conn)
    end

    it 'uses Attribute Builder to process response' do
      expect(Mas::Cms::Repository::CMS::AttributeBuilder).to receive(:build).with(response)
      described_class.find(slug: '/test')
    end
  end
end

require 'mas/cms/entity/page'
RSpec.describe Mas::Cms::Page do
  it_has_behavior 'a cms page entity'
end
