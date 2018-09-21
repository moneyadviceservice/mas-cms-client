# coding: utf-8

require 'mas/cms/repository/cms/attribute_builder'

module Mas::Cms::Repository::CMS
  RSpec.describe AttributeBuilder do
    let(:body) { File.read('spec/fixtures/cms/beginners-guide-to-managing-your-money.json') }
    let(:response) { OpenStruct.new(body: JSON.parse(body)) }
    let(:options) { { locale: 'en' } }

    describe '.build' do
      subject { AttributeBuilder.build(response.body, options) }

      it 'instantiate an attribute builder passing response and options' do
        attribute_builder = double(attributes: {})
        expect(AttributeBuilder).to receive(:new).with(response.body, options).and_return(attribute_builder)
        subject
      end

      it 'returns title' do
        expect(subject['title']).to eq('Beginner’s guide to managing your money')
      end

      it 'returns description' do
        expected = 'How to set up a budget, keep on top of your debts and start to save regularly'
        expect(subject['description']).to eq(expected)
      end

      it 'returns meta_title' do
        expected = 'How to Manage Your Money – Beginner\'s Guide'
        expect(subject['meta_title']).to eq(expected)
      end

      it 'returns categories' do
        expected = ['managing-money', 'taking-control-of-debt'].map do |category_name|
          Mas::Cms::Category.new(category_name, {})
        end
        expect(subject['categories']).to eq(expected)
      end

      it 'returns alternates' do
        expect(subject['alternates']).to eq(
          [
            {
              title: 'Canllaw syml i reoli eich arian',
              url: '/cy/articles/canllaw-syml-i-reoli-eich-arian',
              hreflang: 'cy'
            }
          ]
        )
      end

      it 'returns popular links' do
        expect(subject['related_content']['popular_links']).to be_present
      end

      it 'returns related links' do
        expect(subject['related_content']['related_links']).to be_present
      end

      it 'returns latest blog post links' do
        expect(subject['related_content']['latest_blog_post_links']).to be_present
      end

      it 'returns previous links' do
        expect(subject['related_content']['previous_link']).to_not be_present
      end

      it 'returns next links' do
        expect(subject['related_content']['next_link']).to be_present
      end

      it 'body is html' do
        # rubocop:disable LineLength
        expect(subject['body']).to include('<p><strong>Good money management can mean many things – from living within your means to saving for short and long-term goals, to having a realistic plan to pay off your debts. Read on if you want to learn how to set up a budget, make the most of your money, pay off debts or start saving.</strong></p>')
      end

      context 'when passing another options' do
        let(:body) { File.read('spec/fixtures/cms/canllaw-syml-i-reoli-eich-arian.json') }
        let(:response) { OpenStruct.new(body: JSON.parse(body)) }
        subject { AttributeBuilder.build(response.body, locale: 'cy') }

        it 'returns welsh categories' do
          expect(subject['categories'].size).to be(1)
          expect(subject['categories'].first.title).to eq('Rheoli arian')
          expect(subject['categories'].first.id).to eq('managing-money')
        end
      end

      context 'when parsing another blocks than content' do
        let(:body) { File.read('spec/fixtures/cms/article-components.json') }

        it 'returns blocks excluding content' do
          expect(subject['non_content_blocks']).to match_array(
            [
              Mas::Cms::Block.new(
                identifier: 'component_hero_image',
                content: '<p>/hero-sample.jpg</p>'
              ),
              Mas::Cms::Block.new(
                identifier: 'component_cta_links',
                content: 'cta links content'
              ),
              Mas::Cms::Block.new(
                identifier: 'component_download',
                content: 'something to be downloaded'
              ),
              Mas::Cms::Block.new(
                identifier: 'component_feedback',
                content: '<p>email@moneyadviceservice.org.uk</p>'
              )
            ]
          )
        end
      end

      context 'home page' do
        let(:body) { File.read('spec/fixtures/cms/modifiable-home-page.json') }

        it 'makes raw attributes acessible' do
          expect(subject['heading']).to eql('head 1')
        end

        it 'groups numbered a attributes' do
          expect(subject['tools'][0]['heading']).to eql('head 1')
          expect(subject['tools'][0]['link']).to eql('https://example.com')
        end
      end
    end
  end
end
