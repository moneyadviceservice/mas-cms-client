RSpec.describe Mas::Cms::Resource do
  subject(:entity_class) do
    class A < Mas::Cms::Entity
      attr_accessor :title, :content

      include Mas::Cms::Resource
    end
  end

  let(:conn) { double(:http_connection, get: data_attributes) }
  let(:data_attributes) do
    {
      title:   'entity title',
      content: 'entity content'
    }
  end

  before do
    allow(Mas::Cms::Client).to receive(:connection).and_return(conn)
  end

  describe '#find' do
    let(:find_args) do
      {
        locale: 'en',
        slug: 'how-to-stay-alive'
      }
    end

    context 'successful API call to CMS' do
      let(:entity) { entity_class.find(find_args) }

      it 'returns an instance of entity' do
        expect(entity).to be_instance_of(A)
      end

      it 'returns requested entity' do
        expect(entity.id).to eq(find_args[:slug])
      end

      it 'returns a fully instanciated entity instance' do
        expect(entity.title).to eq(data_attributes[:title])
        expect(entity.content).to eq(data_attributes[:content])
      end
    end
  end
end
