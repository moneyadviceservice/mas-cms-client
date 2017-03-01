RSpec.describe Mas::Cms::FooterReader do

  subject { Mas::Cms::FooterReader.new('footer') }

  describe '#call' do
    it 'creates a Footer object' do
      expect(subject.call).to be_a(Mas::Cms::Footer)
    end
  end
end
