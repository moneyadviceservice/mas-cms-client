module Mas::Cms
  RSpec.describe Clump, type: :model do
    it_has_behavior 'a cms resource entity'
    subject { described_class.new(double, attributes) }

    let(:attributes) do
      {
        name:        double,
        description: double,
        categories:  double,
        links:       double
      }
    end

    it { is_expected.to have_attributes(:name, :description, :categories, :links) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }

    describe 'api_prefix' do
      it 'returns nil' do
        expect(described_class.api_prefix).to be(nil)
      end
    end
  end
end
