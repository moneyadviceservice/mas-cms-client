module Mas::Cms
  RSpec.describe Clump, type: :model do
    it_has_behavior 'a cms resource entity'
    subject { described_class.new(double, attributes) }

    let(:attributes) do
      {
        name: double,
        description: double,
        meta_title: double,
        categories: double,
        links: double
      }
    end

    it { is_expected.to have_attributes(:name, :description, :meta_title, :categories, :links) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }

    describe '.resource_attributes' do
      let(:entity_attrs) do
        {
          'name' => 'Debt & Borrowing',
          'description' => 'Taking control of debt, improving your credit score and low-cost borrowing',
          'links' => [
            { 'id' => 1, 'text' => 'Debt test', 'url' => '/en/tools/debt-test', 'style' => 'tool' }
          ],
          'categories' => [
            {
              'id' => 'debt-and-borrowing',
              'title' => 'Debt and borrowing',
              'contents' => [
                { 'id' => 'before-you-borrow', 'title' => 'Before you borrow', 'type' => 'category' },
                { 'id' => 'taking-control-of-debt', 'title' => 'Taking control of debt', 'type' => 'category' }
              ]
            }
          ]
        }
      end
      let(:category) do
        Category.new('debt-and-borrowing', entity_attrs['categories'][0])
      end
      let(:clump_link) do
        ClumpLink.new(1, 'text' => 'Debt test', 'url' => '/en/tools/debt-test', 'style' => 'tool')
      end
      subject { Clump.resource_attributes(entity_attrs, {}) }

      it 'instantiates categories' do
        expect(subject['categories']).to eq([category])
        expect(subject['categories'].first.contents).to eq(
          [
            Category.new('before-you-borrow', title: 'Before you borrow', type: 'category'),
            Category.new('taking-control-of-debt', title: 'Taking control of debt', type: 'category')
          ]
        )
      end

      it 'instantiates clump links' do
        expect(subject['links']).to eq([clump_link])
      end
    end
  end
end
