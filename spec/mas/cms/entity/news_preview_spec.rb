module Mas::Cms
  RSpec.describe NewsPreview, type: :model do
    it_has_behavior 'a cms page entity'
    it_has_behavior 'a cms preview page'

    subject { described_class.new(double, attributes) }

    it { expect(described_class.superclass).to be(Mas::Cms::News) }
  end
end
