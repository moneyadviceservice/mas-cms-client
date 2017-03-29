module Mas::Cms
  RSpec.describe PageFeedback do
    it_has_behavior 'a cms resource entity'

    describe '.path' do
      subject { described_class.path(locale: 'en', slug: 'personal-pensions') }
      it 'returns cms route' do
        expect(subject).to eq('/api/en/personal-pensions/page_feedbacks')
      end
    end
  end
end
