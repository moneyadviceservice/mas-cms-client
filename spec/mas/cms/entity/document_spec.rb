RSpec.describe Mas::Cms::Document do
  it_has_behavior 'a cms page entity'

  describe '.root_name' do
    it 'returns "documents"' do
      expect(described_class.root_name).to eq('documents')
    end
  end
end
