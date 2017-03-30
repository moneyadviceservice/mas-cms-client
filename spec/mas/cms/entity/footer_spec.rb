RSpec.describe Mas::Cms::Footer, type: :model do
  it_has_behavior 'a cms resource entity'
  let(:params) do
    {
      label: 'Footer',
      blocks: [
        { 'identifier' => 'raw_web_chat_heading', 'content' => 'Web Chat' },
        { 'identifier' => 'raw_web_chat_additional_one', 'content' => 'Monday to Friday, 8am to 8pm' },
        { 'identifier' => 'raw_web_chat_additional_two', 'content' => 'Saturday, 9am to 1pm' },
        { 'identifier' => 'raw_web_chat_additional_three', 'content' => 'Sunday and Bank Holidays, closed' },
        { 'identifier' => 'raw_web_chat_small_print', 'content' => 'some small print' },
        { 'identifier' => 'raw_contact_heading', 'content' => 'Call Us' },
        { 'identifier' => 'raw_contact_introduction', 'content' => 'Give us a call for free advice' },
        { 'identifier' => 'raw_contact_phone_number', 'content' => '555 555 5555 *' },
        { 'identifier' => 'raw_contact_additional_one', 'content' => 'Monday to Friday, 8am to 8pm' },
        { 'identifier' => 'raw_contact_additional_two', 'content' => 'Saturday, 9am to 1pm' },
        { 'identifier' => 'raw_contact_additional_three', 'content' => 'Sunday and Bank Holidays, closed' },
        { 'identifier' => 'raw_contact_small_print', 'content' => '* Calls are free.' }
      ]
    }
  end

  subject { described_class.new('footer', params) }

  describe '#contact' do
    it 'returns a Contact object' do
      expect(subject.contact).to be_a(Mas::Cms::Contact)
    end

    it "doesn't make multiple instances of contact if called multiple times" do
      allow(Mas::Cms::Contact).to receive(:new).and_call_original
      3.times { subject.contact }
      expect(Mas::Cms::Contact).to have_received(:new).once
    end

    it { expect(subject.contact.heading).to eq('Call Us') }
    it { expect(subject.contact.introduction).to eq('Give us a call for free advice') }
    it { expect(subject.contact.phone_number).to eq('555 555 5555 *') }
    it { expect(subject.contact.additional_one).to eq('Monday to Friday, 8am to 8pm') }
    it { expect(subject.contact.additional_two).to eq('Saturday, 9am to 1pm') }
    it { expect(subject.contact.additional_three).to eq('Sunday and Bank Holidays, closed') }
  end
end
