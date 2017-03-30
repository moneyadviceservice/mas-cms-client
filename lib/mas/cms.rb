require 'mas/cms/connection'
require 'mas/cms/resource'
require 'mas/cms/client/version'
require 'mas/cms/client'
require 'active_model'
require 'ostruct'
require 'active_support/core_ext'
require 'tree'

module Mas
  module Cms
    # API Resources
    autoload :Page, 'mas/cms/entity/page'

    autoload :ActionPlan, 'mas/cms/entity/action_plan'
    autoload :Article, 'mas/cms/entity/article'
    autoload :HomePage, 'mas/cms/entity/home_page'
    autoload :Contact, 'mas/cms/entity/contact'
    autoload :Corporate, 'mas/cms/entity/corporate'
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
    autoload :StaticPage, 'mas/cms/entity/static_page'
    autoload :Customer, 'mas/cms/entity/customer'
    autoload :Video, 'mas/cms/entity/video'
    autoload :WebChat, 'mas/cms/entity/web_chat'

    module Feedback
      autoload :Base, 'mas/cms/entity/feedback/base'
      autoload :Article, 'mas/cms/entity/feedback/article'
      autoload :Technical, 'mas/cms/entity/feedback/technical'
    end
  end
end
