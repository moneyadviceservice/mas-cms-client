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
      autoload :Http, 'mas/cms/core/connection/http'
    end

    module ConnectionFactory
      autoload :Http, 'mas/cms/core/connection_factory/http'
    end

    autoload :ActionPlan, 'mas/cms/core/entity/action_plan'
    autoload :Article, 'mas/cms/core/entity/article'
    autoload :HomePage, 'mas/cms/core/entity/home_page'
    autoload :Contact, 'mas/cms/core/entity/contact'
    autoload :CorporateArticle, 'mas/cms/core/entity/corporate_article'
    autoload :ArticleLink, 'mas/cms/core/entity/article_link'
    autoload :Category, 'mas/cms/core/entity/category'
    autoload :Clump, 'mas/cms/core/entity/clump'
    autoload :ClumpLink, 'mas/cms/core/entity/clump_link'
    autoload :CorporateCategory, 'mas/cms/core/entity/corporate_category'
    autoload :Entity, 'mas/cms/core/entity'
    autoload :Footer, 'mas/cms/core/entity/footer'
    autoload :NewsArticle, 'mas/cms/core/entity/news_article'
    autoload :NewsCollection, 'mas/cms/core/entity/news_collection'
    autoload :Other, 'mas/cms/core/entity/other'
    autoload :PageFeedback, 'mas/cms/core/entity/page_feedback'
    autoload :SearchResult, 'mas/cms/core/entity/search_result'
    autoload :SearchResultCollection, 'mas/cms/core/entity/search_result_collection'
    autoload :StaticPage, 'mas/cms/core/entity/static_page'
    autoload :Customer, 'mas/cms/core/entity/customer'
    autoload :Video, 'mas/cms/core/entity/video'
    autoload :WebChat, 'mas/cms/core/entity/web_chat'

    module Feedback
      autoload :Base, 'mas/cms/core/entity/feedback/base'
      autoload :Article, 'mas/cms/core/entity/feedback/article'
      autoload :Technical, 'mas/cms/core/entity/feedback/technical'
    end

    autoload :BaseContentReader, 'mas/cms/core/interactor/base_content_reader'
    autoload :HomePageReader, 'mas/cms/core/interactor/home_page_reader'
    autoload :HomePagePreviewer, 'mas/cms/core/interactor/home_page_previewer'
    autoload :ActionPlanReader, 'mas/cms/core/interactor/action_plan_reader'
    autoload :ArticlePreviewer, 'mas/cms/core/interactor/article_previewer'
    autoload :ArticleReader, 'mas/cms/core/interactor/article_reader'
    autoload :CategoryReader, 'mas/cms/core/interactor/category_reader'
    autoload :CategoryTreeReader, 'mas/cms/core/interactor/category_tree_reader'
    autoload :CategoryTreeReaderWithDecorator, 'mas/cms/core/interactor/category_tree_reader_with_decorator'
    autoload :ClumpsReader, 'mas/cms/core/interactor/clumps_reader'
    autoload :CorporateReader, 'mas/cms/core/interactor/corporate_reader'
    autoload :FeedbackWriter, 'mas/cms/core/interactor/feedback_writer'
    autoload :FooterReader, 'mas/cms/core/interactor/footer_reader'
    autoload :NewsArticleReader, 'mas/cms/core/interactor/news_article_reader'
    autoload :NewsReader, 'mas/cms/core/interactor/news_reader'
    autoload :PageFeedbackCreator, 'mas/cms/core/interactor/page_feedback_creator'
    autoload :PageFeedbackUpdator, 'mas/cms/core/interactor/page_feedback_updator'
    autoload :PageFeedbackAction, 'mas/cms/core/interactor/page_feedback_action'
    autoload :Searcher, 'mas/cms/core/interactor/searcher'
    autoload :StaticPageReader, 'mas/cms/core/interactor/static_page_reader'
    autoload :VideoReader, 'mas/cms/core/interactor/video_reader'
    autoload :VideoPreviewer, 'mas/cms/core/interactor/video_previewer'
    autoload :RedirectReader, 'mas/cms/core/interactor/redirect_reader'

    module Interactors
      module Customer
        autoload :Finder, 'mas/cms/core/interactor/customer/finder'
        autoload :Creator, 'mas/cms/core/interactor/customer/creator'
        autoload :Updater, 'mas/cms/core/interactor/customer/updater'
      end

      autoload :UserUpdater, 'mas/cms/core/interactor/user_updater'
    end

    module Registry
      autoload :Connection, 'mas/cms/core/registry/connection'
      autoload :Repository, 'mas/cms/core/registry/repository'
    end

    module Repository
      autoload :Base, 'mas/cms/core/repository/base'
      autoload :Cache, 'mas/cms/core/repository/cache'
      autoload :VCR, 'mas/cms/core/repository/vcr'

      module ActionPlans
        autoload :PublicWebsite, 'mas/cms/core/repository/action_plans/public_website'
        autoload :CMS, 'mas/cms/core/repository/action_plans/cms'
      end

      module Articles
        autoload :Fake, 'mas/cms/core/repository/articles/fake'
        autoload :PublicWebsite, 'mas/cms/core/repository/articles/public_website'
        autoload :CMS, 'mas/cms/core/repository/articles/cms'
      end

      module HomePages
        autoload :CMS, 'mas/cms/core/repository/home_pages/cms'
        autoload :Static, 'mas/cms/core/repository/home_pages/static'
      end

      module Footer
        autoload :CMS, 'mas/cms/core/repository/footer/cms'
        autoload :Static, 'mas/cms/core/repository/footer/static'
      end

      module Corporate
        autoload :CMS, 'mas/cms/core/repository/corporate/cms'
      end

      module Videos
        autoload :PublicWebsite, 'mas/cms/core/repository/videos/public_website'
        autoload :CMS, 'mas/cms/core/repository/videos/cms'
      end

      module Categories
        autoload :Fake, 'mas/cms/core/repository/categories/fake'
        autoload :CMS, 'mas/cms/core/repository/categories/cms'
      end

      module Clumps
        autoload :CMS, 'mas/cms/core/repository/clumps/cms'
      end

      module Feedback
        autoload :Email, 'mas/cms/core/repository/feedback/email'
      end

      module Customers
        autoload :Fake, 'mas/cms/core/repository/customers/fake'
        autoload :Cream, 'mas/cms/core/repository/customers/cream'
      end

      module CMS
        autoload :AttributeBuilder, 'mas/cms/core/repository/cms/attribute_builder'
        autoload :CMS, 'mas/cms/core/repository/cms/cms'
        autoload :Resource301Error, 'mas/cms/core/repository/cms/cms'
        autoload :Resource302Error, 'mas/cms/core/repository/cms/cms'
        autoload :CmsApi, 'mas/cms/core/repository/cms/cms_api'
        autoload :BlockComposer, 'mas/cms/core/repository/cms/block_composer'
        autoload :PageFeedback, 'mas/cms/core/repository/cms/page_feedback'
        autoload :Preview, 'mas/cms/core/repository/cms/preview'
      end

      module News
        autoload :PublicWebsite, 'mas/cms/core/repository/news/public_website'
        autoload :CMS, 'mas/cms/core/repository/news/cms'
      end

      module RecommendedTools
        autoload :Static, 'mas/cms/core/repository/recommended_tools/static'
      end

      module SavedTools
        autoload :Static, 'mas/cms/core/repository/saved_tools/static'
      end

      module StaticPages
        autoload :PublicWebsite, 'mas/cms/core/repository/static_pages/public_website'
        autoload :Cms, 'mas/cms/core/repository/static_pages/cms'
      end

      module Search
        autoload :ContentService, 'mas/cms/core/repository/search/content_service'
        autoload :GoogleCustomSearchEngine, 'mas/cms/core/repository/search/google_custom_search_engine'
      end

      module Users
        autoload :Default, 'mas/cms/core/repository/users/default'
      end
    end
  end
end
