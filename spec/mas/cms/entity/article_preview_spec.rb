module Mas::Cms
  RSpec.describe ArticlePreview, type: :model do
    it_has_behavior 'a cms page entity'
    subject { described_class.new(double, attributes) }

    it { expect(described_class.superclass).to be(Mas::Cms::Article) }

    describe '.path' do
      subject(:path) do
        described_class.path(slug: 'foo', locale: 'en')
      end

      it 'returns article preview path' do
        expect(path).to eq('/api/preview/en/foo.json')
      end
    end
  end
end
