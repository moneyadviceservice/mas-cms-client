module Mas::Cms
  RSpec.describe VideoPreview, type: :model do
    it_has_behavior 'a cms page entity'
    it_has_behavior 'a cms preview page'

    subject { described_class.new(double, attributes) }

    it { expect(described_class.superclass).to be(Mas::Cms::Video) }
  end
end
