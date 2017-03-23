RSpec.describe Mas::Cms::Resource do
  subject(:entity_class) do
    class A < Mas::Cms::Entity
      attr_accessor :title, :content
      include Mas::Cms::Resource
      resource_type :poker_card
    end
    A
  end

  let(:specific_entity_class) do
    class BarFoo < Mas::Cms::Entity
      attr_accessor :call_to_action, :body_content
      include Mas::Cms::Resource

      def self.process_response(response)
        {
          call_to_action: response.body[:title],
          body_content: response.body[:content]
        }
      end
    end
    BarFoo
  end

  let(:modularized_entity) do
    module ModularizedEntity
      module Foo
        class Bar < ::Mas::Cms::Entity
          include Mas::Cms::Resource
        end
      end
    end
  end

  let(:data_attributes) { {} }
  let(:conn) { spy(:http_connection, get: double(body: data_attributes)) }

  before do
    allow(Mas::Cms::Client).to receive(:connection).and_return(conn)
  end

  describe '.resource_name' do
    context 'when resource_type is defined' do
      it 'is not pluralized' do
        expect(entity_class.resource_name).to eq('poker_card')
      end
    end

    context 'when resource_type is not defined' do
      it 'is pluralized' do
        expect(specific_entity_class.resource_name).to eq('bar_foos')
      end
    end

    context 'when resource class is under a module' do
      it 'returns pluralized name without the module' do
        expect(modularized_entity.resource_name).to eq('bars')
      end
    end
  end

  describe '.find' do
    let(:data_attributes) do
      {
        title:   'entity title',
        content: 'entity content'
      }
    end

    let(:args) do
      {
        locale: 'en',
        slug: 'how-to-stay-alive'
      }
    end
    let(:entity) { entity_class.find(args) }

    context 'when API call successful' do
      it 'returns an instance of entity' do
        expect(entity).to be_instance_of(A)
      end

      it 'query correct cms resource' do
        entity
        expect(conn).to have_received(:get).with('/api/en/poker_card/how-to-stay-alive.json')
      end

      it 'returns requested entity' do
        expect(entity.id).to eq(args[:slug])
      end

      it 'returns a fully instanciated entity instance' do
        expect(entity.title).to eq(data_attributes[:title])
        expect(entity.content).to eq(data_attributes[:content])
      end

      context 'locale params defaults to `en`' do
        let(:args) { {slug: 'no-way'} }

        it 'returns an instance of entity' do
          expect(entity).to be_instance_of(A)
        end
      end
    end

    context 'when specific entity class' do
      let(:entity) { specific_entity_class.find(args) }

      it 'overwrites original parser' do
        expect(entity.call_to_action).to eq(data_attributes[:title])
        expect(entity.body_content).to eq(data_attributes[:content])
      end
    end
  end

  describe '.all' do
    let(:data_attributes) do
      [
        {
          id:  'my-first-entity',
          title:   'entity title',
          content: 'entity content'
        },
        {
          id:  'my-second-entity',
          title:   'foo title',
          content: 'bar content'
        }
      ]
    end

    let(:args) do
      {
        locale: 'en',
      }
    end
    let(:entities) { entity_class.all(args) }

    context 'when API call successful' do
      it 'returns an array of entity' do
        expect(entities).to all(be_an(A))
      end

      it 'returns a fully instantiated entities instance' do
        expect(entities[1].title).to eq(data_attributes[1][:title])
        expect(entities[1].content).to eq(data_attributes[1][:content])
      end

      it 'query correct cms resource' do
        entities
        expect(conn).to have_received(:get).with('/api/en/poker_card.json')
      end

      context 'locale params defaults to `en`' do
        let(:args) { {} }

        it 'returns an array of entity' do
          expect(entities).to all(be_an(A))
        end
      end
    end
  end
end