RSpec.shared_examples_for 'a cms preview page' do
  it 'behaves as a preview' do
    expect(described_class.included_modules).to include(Mas::Cms::Preview)
  end

  describe '.path' do
    subject(:path) do
      described_class.path(slug: 'some-page-id', locale: 'en')
    end

    it 'returns preview path' do
      expect(path).to eq('/api/preview/en/some-page-id.json')
    end
  end
end
