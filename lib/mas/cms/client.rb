require 'mas/cms/client/version'
require 'faraday'
require 'faraday_middleware'
require 'active_model'
require 'ostruct'
require 'active_support/core_ext'
require 'tree'

module Mas
  module Cms
    module Connection
      autoload :Http, 'mas/cms/connection/http'
    end

    module ConnectionFactory
      autoload :Http, 'mas/cms/connection_factory/http'
    end

    autoload :ActionPlan, 'mas/cms/entity/action_plan'
    autoload :Article, 'mas/cms/entity/article'
    autoload :HomePage, 'mas/cms/entity/home_page'
    autoload :Contact, 'mas/cms/entity/contact'
    autoload :CorporateArticle, 'mas/cms/entity/corporate_article'
    autoload :ArticleLink, 'mas/cms/entity/article_link'
    autoload :Category, 'mas/cms/entity/category'
    autoload :Clump, 'mas/cms/entity/clump'
    autoload :ClumpLink, 'mas/cms/entity/clump_link'
    autoload :CorporateCategory, 'mas/cms/entity/corporate_category'
    autoload :Entity, 'mas/cms/entity'
    autoload :Footer, 'mas/cms/entity/footer'
    autoload :NewsArticle, 'mas/cms/entity/news_article'
    autoload :NewsCollection, 'mas/cms/entity/news_collection'
    autoload :Other, 'mas/cms/entity/other'
    autoload :PageFeedback, 'mas/cms/entity/page_feedback'
    autoload :SearchResult, 'mas/cms/entity/search_result'
    autoload :SearchResultCollection, 'mas/cms/entity/search_result_collection'
    autoload :StaticPage, 'mas/cms/entity/static_page'
    autoload :Customer, 'mas/cms/entity/customer'
    autoload :Video, 'mas/cms/entity/video'
    autoload :WebChat, 'mas/cms/entity/web_chat'

    module Feedback
      autoload :Base, 'mas/cms/entity/feedback/base'
      autoload :Article, 'mas/cms/entity/feedback/article'
      autoload :Technical, 'mas/cms/entity/feedback/technical'
    end

    autoload :BaseContentReader, 'mas/cms/interactor/base_content_reader'
    autoload :HomePageReader, 'mas/cms/interactor/home_page_reader'
    autoload :HomePagePreviewer, 'mas/cms/interactor/home_page_previewer'
    autoload :ActionPlanReader, 'mas/cms/interactor/action_plan_reader'
    autoload :ArticlePreviewer, 'mas/cms/interactor/article_previewer'
    autoload :ArticleReader, 'mas/cms/interactor/article_reader'
    autoload :CategoryReader, 'mas/cms/interactor/category_reader'
    autoload :CategoryTreeReader, 'mas/cms/interactor/category_tree_reader'
    autoload :CategoryTreeReaderWithDecorator, 'mas/cms/interactor/category_tree_reader_with_decorator'
    autoload :ClumpsReader, 'mas/cms/interactor/clumps_reader'
    autoload :CorporateReader, 'mas/cms/interactor/corporate_reader'
    autoload :FeedbackWriter, 'mas/cms/interactor/feedback_writer'
    autoload :FooterReader, 'mas/cms/interactor/footer_reader'
    autoload :NewsArticleReader, 'mas/cms/interactor/news_article_reader'
    autoload :NewsReader, 'mas/cms/interactor/news_reader'
    autoload :PageFeedbackCreator, 'mas/cms/interactor/page_feedback_creator'
    autoload :PageFeedbackUpdator, 'mas/cms/interactor/page_feedback_updator'
    autoload :PageFeedbackAction, 'mas/cms/interactor/page_feedback_action'
    autoload :Searcher, 'mas/cms/interactor/searcher'
    autoload :StaticPageReader, 'mas/cms/interactor/static_page_reader'
    autoload :VideoReader, 'mas/cms/interactor/video_reader'
    autoload :VideoPreviewer, 'mas/cms/interactor/video_previewer'
    autoload :RedirectReader, 'mas/cms/interactor/redirect_reader'

    module Interactors
      module Customer
        autoload :Finder, 'mas/cms/interactor/customer/finder'
        autoload :Creator, 'mas/cms/interactor/customer/creator'
        autoload :Updater, 'mas/cms/interactor/customer/updater'
      end

      autoload :UserUpdater, 'mas/cms/interactor/user_updater'
    end

    module Registry
      autoload :Connection, 'mas/cms/registry/connection'
      autoload :Repository, 'mas/cms/registry/repository'
    end

    module Repository
      autoload :Base, 'mas/cms/repository/base'
      autoload :Cache, 'mas/cms/repository/cache'
      autoload :VCR, 'mas/cms/repository/vcr'

      module ActionPlans
        autoload :PublicWebsite, 'mas/cms/repository/action_plans/public_website'
        autoload :CMS, 'mas/cms/repository/action_plans/cms'
      end

      module Articles
        autoload :Fake, 'mas/cms/repository/articles/fake'
        autoload :PublicWebsite, 'mas/cms/repository/articles/public_website'
        autoload :CMS, 'mas/cms/repository/articles/cms'
      end

      module HomePages
        autoload :CMS, 'mas/cms/repository/home_pages/cms'
        autoload :Static, 'mas/cms/repository/home_pages/static'
      end

      module Footer
        autoload :CMS, 'mas/cms/repository/footer/cms'
        autoload :Static, 'mas/cms/repository/footer/static'
      end

      module Corporate
        autoload :CMS, 'mas/cms/repository/corporate/cms'
      end

      module Videos
        autoload :PublicWebsite, 'mas/cms/repository/videos/public_website'
        autoload :CMS, 'mas/cms/repository/videos/cms'
      end

      module Categories
        autoload :Fake, 'mas/cms/repository/categories/fake'
        autoload :CMS, 'mas/cms/repository/categories/cms'
      end

      module Clumps
        autoload :CMS, 'mas/cms/repository/clumps/cms'
      end

      module Feedback
        autoload :Email, 'mas/cms/repository/feedback/email'
      end

      module Customers
        autoload :Fake, 'mas/cms/repository/customers/fake'
        autoload :Cream, 'mas/cms/repository/customers/cream'
      end

      module CMS
        autoload :AttributeBuilder, 'mas/cms/repository/cms/attribute_builder'
        autoload :CMS, 'mas/cms/repository/cms/cms'
        autoload :Resource301Error, 'mas/cms/repository/cms/cms'
        autoload :Resource302Error, 'mas/cms/repository/cms/cms'
        autoload :CmsApi, 'mas/cms/repository/cms/cms_api'
        autoload :BlockComposer, 'mas/cms/repository/cms/block_composer'
        autoload :PageFeedback, 'mas/cms/repository/cms/page_feedback'
        autoload :Preview, 'mas/cms/repository/cms/preview'
      end

      module News
        autoload :PublicWebsite, 'mas/cms/repository/news/public_website'
        autoload :CMS, 'mas/cms/repository/news/cms'
      end

      module RecommendedTools
        autoload :Static, 'mas/cms/repository/recommended_tools/static'
      end

      module SavedTools
        autoload :Static, 'mas/cms/repository/saved_tools/static'
      end

      module StaticPages
        autoload :PublicWebsite, 'mas/cms/repository/static_pages/public_website'
        autoload :Cms, 'mas/cms/repository/static_pages/cms'
      end

      module Search
        autoload :ContentService, 'mas/cms/repository/search/content_service'
        autoload :GoogleCustomSearchEngine, 'mas/cms/repository/search/google_custom_search_engine'
      end

      module Users
        autoload :Default, 'mas/cms/repository/users/default'
      end
    end
  end
end
