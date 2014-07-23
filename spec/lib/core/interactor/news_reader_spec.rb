require_relative 'shared_examples/optional_failure_block'

module Core
  RSpec.describe NewsReader do
    subject(:news_reader) { described_class.new(options) }

    let(:page) { 2 }
    let(:limit) { 11 }
    let(:options) { { page_number: page, limit: limit } }
    let(:public_website) { double }

    before do
      allow(Registry::Repository).to receive(:[]).with(:news) do
        double(all: data)
      end

      allow(public_website).to receive(:all).with(page: 2, limit: 11).and_return(data)
      allow(Registry::Repository).to receive(:[]).with(:news).and_return(public_website)
    end

    describe '#call' do
      context 'when the repository returns no data' do
        let(:data) { nil }

        it_behaves_like 'optional failure block'
      end

      context 'when the repository returns an empty collection' do
        let(:data) { [] }

        it_behaves_like 'optional failure block'
      end

      context 'when the repository returns data' do
        subject(:news) { news_reader.call }

        let(:data) do
          [{
            'id'    => 'news-article-id',
            'title' => 'The title',
            'body'  => 'the body',
            'date'  => '23/09/2011'
          }]
        end

        it { is_expected.to be_a(NewsCollection) }

        specify 'colection items are news article entities' do
          expect(news.first).to be_a(NewsArticle)
        end
      end
    end
  end
end
