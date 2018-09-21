module Mas::Cms
  RSpec.describe Category, type: :model do
    subject { described_class.new(double, attributes) }

    let(:attributes) do
      {
        title:       double,
        parent_id:   double,
        description: double,
        meta_title:  double,
        contents:    double,
        images:      double,
        links:       double,
        category_promos: double,
        legacy_contents: double
      }
    end

    it { is_expected.to have_attributes(:type, :parent_id, :title, :description, :meta_title, :contents) }
    it { is_expected.to have_attributes(:images, :links, :category_promos, :legacy_contents, :url_path) }
    it { is_expected.to validate_presence_of(:title) }

    specify { expect(subject).to_not be_home }
    specify { expect(subject).to_not be_news }

    it 'includes Mas::Cms::Resource' do
      expect(described_class.included_modules).to include(Mas::Cms::Resource)
    end

    describe '.resource_attributes' do
      context 'when type is category' do
        let(:response) do
          double(body: ActiveSupport::HashWithIndifferentAccess.new(response_body))
        end

        let(:response_body) do
          {
            contents: [
              { type: nil, id: 'making-will' }
            ]
          }
        end

        it 'calls find on Category resource with locales' do
          expect(Category).to receive(:find).with('making-will', locale: 'cy', cached: true)
          Category.resource_attributes(response.body, locale: 'cy', cached: true)
        end
      end
    end

    describe 'category hierarchy' do
      let(:category_with_nil_contents) { build :category, contents: nil }
      let(:child_category) { build :category, contents: [build(:article), build(:action_plan)] }
      let(:parent_category) { build :category, contents: [child_category] }
      let(:category_with_legacy_contents) { build :category, legacy_contents: [build(:article)], legacy: true }

      specify { expect(category_with_nil_contents).to be_child }

      specify { expect(child_category).to be_child }
      specify { expect(child_category).to_not be_parent }

      specify { expect(parent_category).to be_parent }
      specify { expect(parent_category).to_not be_child }

      specify { expect(category_with_legacy_contents.legacy?).to be true }
    end

    describe '#categories' do
      let(:category) { double(type: 'category') }
      let(:another_category) { double(type: 'category') }
      let(:article) { double(type: 'article') }

      before { attributes[:contents] = [category, article, another_category] }

      it 'only returns the categories' do
        expect(subject.categories).to eq [category, another_category]
      end
    end
  end
end
