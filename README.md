# Mas::Cms::Client

## Purpose

This library provides an application programming interface (API) for retrieving
data from the MAS content management system.

## Features
  - Content caching
  - Loading locale-specific content
  - Diagnosis for HTTP connections

## Installation

### In Gemfile
In order to install this as part of your application.

1. Add this line to your application's Gemfile:

```ruby
gem 'mas-cms-client'
```

2. Install using `bundler`:

    `$ bundle`

### In Local Ruby Gemset (1)
Or install it as part of your global gemset:

    `$ gem install mas-cms-client`

### In Local Ruby Gemset (2)
Install this gem onto your local machine,
    `$ bundle exec rake install`

## Configuration
The following example should help you to configure your application to fetch
data from the content management system.

```ruby
#in file: config/initializers/mas_cms_client.rb`

Mas::Cms::Client.config do |c|
  # Integer, time in seconds spent waiting for connection to be established
  c.timeout =  ENV['HTTP_REQUEST_TIMEOUT'].to_i

  # Integer, time in seconds spent waiting while the connection is established
  c.open_timeout =  ENV['HTTP_REQUEST_TIMEOUT'].to_i

  # String, API token used while submitting a page feedback
  c.api_token =  ENV['MAS_CMS_API_TOKEN']

  # String, CMS URL endpoint for all http requests
  c.host =  ENV['MAS_CMS_URL']

  # Integer, control how many http retries are done before throwinf an error
  c.retries = 1

  # Ruby Object, must respond to `.fetch(key, &block)`
  c.cache = Rails.cache

  # Boolean, controls the default setting for caching ALL 'GET' API calls
  c.cache_gets  = false
end
```

In a Rails project you would have that snippet in a `config/initializers/mas_cms_client.rb` file.

## Usage

### Page API

This is an object representing every cms page created by the editors team.
You can retrieve the page, to see the page content and related content.
Every page has its own type.

The gems supports the following types:

  * Article
  * Action Plan
  * Corporate
  * Category
  * News
  * Video
  * Home Page
  * Footer

The CMS API only support a GET request to pages at the moment
and you can **find any page** by the following:

Some examples of how to retrieve data from the CMS are given below.

```ruby
Mas::Cms::Article.find('how-to-apply-for-a-mortgage')
# GET /api/en/articles/how-to-apply-for-a-mortgage.json

Mas::Cms::ActionPlan.find('next-steps-if-you-cant-get-a-mortgage')
# GET /api/en/action_plans/next-steps-if-you-cant-get-a-mortgage.json

Mas::Cms::Corporate.find('media-comment--money-mental-health-missing-link-report')
# GET /api/en/action_plans/next-steps-if-you-cant-get-a-mortgage.json

Mas::Cms::Category.find('pensions-and-retirement')
# GET /api/en/categories/pensions-and-retirement.json

Mas::Cms::News.find('new-rules-could-make-it-harder-to-get-a-payday-loan')
# GET /api/en/news/new-rules-could-make-it-harder-to-get-a-payday-loan.json

Mas::Cms::Video.find('budgeting-for-retirement')
# GET /api/en/videos/budgeting-for-retirement.json

Mas::Cms::HomePage.find('the-money-advice-service')
# GET /api/en/home_pages/the-money-advice-service.json

Mas::Cms::Footer.find('footer')
# GET /api/en/footers/footer.json
```

### Switching Locale

The gem *uses 'en' locale* as default. But you can pass another locale as
option:

```ruby
Mas::Cms::Article.find('canllaw-i-dreth-etifeddiaeth', locale: 'cy')
# GET http://localhost:3000/api/cy/articles/canllaw-i-dreth-etifeddiaeth.json
```

If you're using Rails, you can take advantage of the I18n module:

```ruby
I18n.locale
# >> 'cy'

Mas::Cms::Article.find('canllaw-i-dreth-etifeddiaeth', locale: I18n.locale)
# GET http://localhost:3000/api/cy/articles/canllaw-i-dreth-etifeddiaeth.json
```

## Cache requests

In this example the first parameter of the method `params[:id]` represents the article's slug i.e. 'personal-pensions'. It is a mandatory parameter.
If the option for `:cached` is set to true the gem will fetch the cache from the object passed in [TODO: needs further clarity. _Did you mean to say that the gem will fetch the object from the cache?_].

`Mas::Cms::Client.config.cache` (usually Rails.cache object in case a Rails
app).
If the :cached is omitted it will default to the value held in
`Mas::Cms::Client.config.cache_gets`.
If the :cached `nil` is passed the call will not be cached.

```ruby
Mas::Cms::Article.find('how-to-apply-for-a-mortgage', cached: true)

Mas::Cms::Category.all(cached: true)
```

## Redirect feature

The following example shows how to retrieve a single localised cms resource with cache enabled and redirection support.

```ruby
class ArticlesController < ApplicationController
  rescue_from Mas::Cms::HttpRedirect, with: :redirect_page

  def show
    @article = Mas::Cms::Article.find(params[:id], locale: I18n.locale, cached: true)
  end

  private

  def redirect_page(e)
    redirect_to e.location, status: e.http_response.status
  end
end
```

### Handling exceptions

The MAS CMS API raises custom exceptions and returns http status error for bad requests.

These are the exceptions that the gem raises:

  * Mas::Cms::Errors::ConnectionFailed
  * Mas::Cms::Errors::ClientError
  * Mas::Cms::Errors::ResourceNotFound
  * Mas::Cms::Errors::UnprocessableEntity

In order to handle the exception you need to catch those exceptions.

This is an example of how the Page Feedback API will handle an exception raised
as a result of trying to 'like' a page.

```ruby
class PageFeedbackController < ApplicationController
  rescue_from Mas::Cms::Errors::UnprocessableEntity, with: :render_form

  def create
    @page_feedback = Mas::Cms::PageFeedback.create(params)
  end

  private

  def render_form
    render :form
  end
end
```

## Development
i. Checkout the repository
  `git clone -b <name-of-branch> git@github.com:moneyadviceservice.git`

ii. Install dependencies
  `bin/setup`

iii. Run all test
  `rake spec`

Optionally, you can also run `bin/console` for an interactive prompt that will allow you to make requests using the entities.

### Release a New Version
i. Update the version number in _lib/mas-cms-client/version.rb_.

ii. Run `$ bundle exec rake release`. This will create a git tag for the newly added gem version, push all outstanding git commits and tags and push the `.gem` file to [rubygems.org](https://rubygems.org).

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
