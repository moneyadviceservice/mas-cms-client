require_relative 'shared_examples/optional_failure_block'

module Mas::Cms
  RSpec.describe ArticleReader do
    subject { described_class.new(id) }

    let(:id) { 'the-article' }

    describe '.call' do
      let(:repository_double) { double(find: data) }

      before do
        allow(Registry::Repository).to receive(:[]).with(:article) do
          repository_double
        end
      end

      context 'when the repository returns no data' do
        let(:data) { nil }

        it_has_behavior 'optional failure block'
      end

      context 'when the repository returns data' do
        let(:title) { 'The Article' }
        let(:description) { 'The Article has a description' }
        let(:body) { '<h1>The Article</h1><p>Lorem ipsum dolor sit amet</p>' }
        let(:categories) { [] }

        let(:data) do
          { title: title, description: description, body: body, categories: categories }
        end

        it 'instantiates the article with the id and the attributes from the repository' do
          expect(Article)
            .to receive(:new).with(id, data).and_call_original

          subject.call
        end

        context 'when the Article entity is valid' do
          before do
            expect_any_instance_of(Article).to receive(:valid?) { true }
          end

          it 'returns an article' do
            expect(subject.call).to be_a(Article)
          end
        end

        context 'when the Article is invalid' do
          before do
            expect_any_instance_of(Article).to receive(:valid?) { false }
          end

          it_has_behavior 'optional failure block'
        end

        context 'when there is a category' do
          let(:category) { 'foo' }
          let(:categories) { [category] }
          let(:category_entity) { double }

          before do
            allow_any_instance_of(CategoryReader).to receive(:call) { category_entity }
          end

          it 'instantiates a category reader with the category' do
            expect(CategoryReader).to receive(:new).with(category).and_call_original
            subject.call
          end

          it 'calls the category reader' do
            expect_any_instance_of(CategoryReader).to receive(:call)
            subject.call
          end

          it 'returns the category reader results' do
            expect(subject.call.categories).to eql [category_entity]
          end
        end
      end

      context 'when find raises Mas::Cms::Repository::CMS::Resource301Error' do
        let(:repository_double) do
          repo = double
          allow(repo).to receive(:find).and_raise(Mas::Cms::Repository::CMS::Resource301Error.new('https://example.com'))
          repo
        end

        it 'returns an object with status 301' do
          subject.call do |article|
            expect(article.status).to eql(301)
          end
        end

        it 'returns an object with the redirect location' do
          subject.call do |article|
            expect(article.location).to eql('https://example.com')
          end
        end

        it 'returns an object with redirect? is true' do
          subject.call do |article|
            expect(article.redirect?).to be_truthy
          end
        end
      end

      context 'when find raises Mas::Cms::Repository::CMS::Resource302Error' do
        let(:repository_double) do
          repo = double
          allow(repo).to receive(:find).and_raise(Mas::Cms::Repository::CMS::Resource302Error.new('https://example.com'))
          repo
        end

        it 'returns an object with status 302' do
          subject.call do |article|
            expect(article.status).to eql(302)
          end
        end

        it 'returns an object with the redirect location' do
          subject.call do |article|
            expect(article.location).to eql('https://example.com')
          end
        end

        it 'returns an object with redirect? is true' do
          subject.call do |article|
            expect(article.redirect?).to be_truthy
          end
        end
      end
    end
  end
end
