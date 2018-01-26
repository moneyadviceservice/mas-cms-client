module Mas::Cms
  RSpec.describe VideoPreview, type: :model do
    it_has_behavior 'a cms page entity'
    subject { described_class.new(double, attributes) }

    it { expect(described_class.superclass).to be(Mas::Cms::Video) }

    describe '.path' do
      subject(:path) do
        described_class.path(slug: 'fake-video', locale: 'en')
      end

      it 'returns video preview path' do
        expect(path).to eq('/api/preview/en/fake-video.json')
      end
    end
  end
end
