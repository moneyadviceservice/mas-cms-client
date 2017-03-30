RSpec.describe Mas::Cms::HttpRedirect do
  subject(:http_redirect) { Mas::Cms::HttpRedirect.new(response) }
  let(:response)          { double(headers: headers, status: status) }
  let(:headers)           { { 'Location' => location } }
  let(:location)          { 'http://example.com' }
  let(:status)            { 301 }

  describe '.redirect?' do
    context 'when http status is 200' do
      let(:status) { 200 }
      it 'returns false' do
        expect(Mas::Cms::HttpRedirect.redirect?(response)).to be false
      end
    end

    context 'when http status is 301' do
      it 'returns true' do
        expect(Mas::Cms::HttpRedirect.redirect?(response)).to be true
      end
    end

    context 'when http status is 302' do
      let(:status) { 302 }
      it 'returns true' do
        expect(Mas::Cms::HttpRedirect.redirect?(response)).to be true
      end
    end
  end

  describe '#locaction' do
    let(:location) { 'http://example.com' }
    it 'returns redirect location' do
      expect(http_redirect.location).to eq location
    end
  end
end
