module Mas::Cms
  RSpec.describe HomePagePreview, type: :model do
    it_has_behavior 'a cms page entity'
    subject { described_class.new(double, attributes) }

    it { expect(described_class.superclass).to be(Mas::Cms::HomePage) }

    describe '.path' do
      subject(:path) do
        described_class.path(slug: 'home', locale: 'en')
      end

      it 'returns home page preview path' do
        expect(path).to eq('/api/preview/en/home.json')
      end
    end
  end
end
