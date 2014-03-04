require 'spec_helper'
require 'core/repositories/categories/fake'

describe Core::Repositories::Categories::Fake do
  let(:valid_id) { 'category-1' }
  let(:valid_subcategory_id) { 'subcategory-1' }
  let(:invalid_id) { 'fake' }

  describe '#all' do
    subject { described_class.new.all }

    it { should be_a(Array) }
    specify { expect(subject.first['id']).to eq(valid_id) }
  end

  describe '#find' do
    context 'when the category exists' do
      subject { described_class.new.find(valid_id) }

      it { should be_a(Hash) }
      specify { expect(subject['id']).to eq(valid_id) }

      it 'instantiates a valid Category' do
        expect(Core::Category.new(subject['id'], subject)).to be_valid
      end

      it 'instantiates a valid Category from the subcategory' do
        subcategory = subject['contents'].first
        expect(Core::Category.new(subcategory['id'], subcategory)).to be_valid
      end

      context 'when retrieving a subcategory' do
        subject { described_class.new.find(valid_subcategory_id) }

        it { should be_a(Hash) }
        specify { expect(subject['id']).to eq(valid_subcategory_id) }
      end
    end

    context 'when the category is non-existent' do
      subject { described_class.new.find(invalid_id) }

      it { should be_nil }
    end
  end
end
