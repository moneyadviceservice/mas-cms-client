module Mas::Cms
  RSpec.describe HomePage, type: :model do
    it_has_behavior 'a cms page entity'
    subject { described_class.new(double, attributes) }

    let(:attributes) { Hash.new }

    it 'has correct attributes' do
      [:promo_banner_url, :promo_banner_url].each do |attr|
        expect(subject).to respond_to(attr)
      end
    end
  end
end
