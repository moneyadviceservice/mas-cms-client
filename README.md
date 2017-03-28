# Mas::Cms::Client

## Purpose

Provide a library responsible for the communication with `MAS CMS`.

It provides a caching mechanism, support different locales and raise a few exceptions which can be used to detect connection issues and http redirection.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mas-cms-client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mas-cms-client


## Configuration

Being you are able to use the different entity classes available, you have to configure the library.

```ruby
Mas::Cms::Client.config do |c|
  # Integer, time in seconds spent waiting for connection to be established
  c.timeout =  ENV['HTTP_REQUEST_TIMEOUT'].to_i

  # Integer, time in seconds spent waiting while the connection is established
  c.open_timeout =  ENV['HTTP_REQUEST_TIMEOUT'].to_i

  # String, api token used while submitting a page feedback
  c.api_token =  ENV['MAS_CMS_API_TOKEN']

  # String, represents CMS URL that the gem will make the requests to.
  c.host =  ENV['MAS_CMS_URL']

  # Integer, control how many http retries are done before erroring
  c.retries = 1

  # Ruby Object, must respond to `.fetch(key, &block)`
  c.cache = Rails.cache

  # Boolean, controls the default setting for caching ALL 'GET' api calls
  c.cache_gets  = false
end
```

In a Rails project you would have that snippet in a `config/initializers/mas_cms_client.rb` file.

## Usage

### Page API

This is an object representing every cms page created by the editors team.
You can retrieve the page, to see the page content and related content too.
Every page has your own type.

These are the following types that the gem supports:

* Article
* Action Plan
* Corporate
* News
* Video
* Home Page
* Footer

The CMS API only support a GET request to pages at the moment
and you can **find any page** by the following:

Each line described below will make a request to CMS to your own page type:

```ruby
Mas::Cms::Article.find('how-to-apply-for-a-mortgage')
# GET /api/en/articles/how-to-apply-for-a-mortgage.json

Mas::Cms::ActionPlan.find('next-steps-if-you-cant-get-a-mortgage')
# GET /api/en/action_plans/next-steps-if-you-cant-get-a-mortgage.json

Mas::Cms::Corporate.find('media-comment--money-mental-health-missing-link-report')
# GET /api/en/action_plans/next-steps-if-you-cant-get-a-mortgage.json

Mas::Cms::News.find('new-rules-could-make-it-harder-to-get-a-payday-loan')
# GET /api/en/news/new-rules-could-make-it-harder-to-get-a-payday-loan.json

Mas::Cms::Video.find('budgeting-for-retirement')
# GET /api/en/videos/budgeting-for-retirement.json

Mas::Cms::HomePage.find('the-money-advice-service')
# GET /api/en/home_pages/the-money-advice-service.json

Mas::Cms::Footer.find('footer')
# GET /api/en/footers/footer.json
```

### Locale feature

The gem *uses 'en' locale* as default. But you can pass another locale as
option:

```ruby
Mas::Cms::Article.find('canllaw-i-dreth-etifeddiaeth', locale: 'cy')
# GET http://localhost:3000/api/cy/articles/canllaw-i-dreth-etifeddiaeth.json
```

If you're using Rails, you can take advatnage on the I18n module:

```ruby
I18n.locale
# >> 'cy'

Mas::Cms::Article.find('canllaw-i-dreth-etifeddiaeth', locale: I18n.locale)
# GET http://localhost:3000/api/cy/articles/canllaw-i-dreth-etifeddiaeth.json
```

## Cache requests

In this example the first parameter of the method `params[:id]` reprensents the article's slug ie 'personal-pensions'. It is a mandatory parameter.
If the :cached is true, the gem will fetch the cache from the object passed in
`Mas::Cms::Client.config.cache` (usually Rails.cache object in case a Rails
app).
If the :cached is omitted it will default to the value hold in
`Mas::Cms::Client.config.cache_gets`.
If the :cached `nil` is passed the call will not be cached.

```ruby
Mas::Cms::Article.find('how-to-apply-for-a-mortgage', cached: true)

Mas::Cms::Category.all(cached: true)
```

## Redirect feature

The following example show how to retrieve one cms resource with cache enable, redirection support and localisation:

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

In all the requests, the API can return http errors, so the gem raises custom
exceptions for http errors in the calls.

These are the exceptions that the gem raises:

* Mas::Cms::Errors::ConnectionFailed
* Mas::Cms::Errors::ClientError
* Mas::Cms::Errors::ResourceNotFound
* Mas::Cms::Errors::UnprocessableEntity

In order to handle the exception you need to catch those exceptions.

An example below is try to use the Page Feedback API, trying
to create a like for a page, handling an exception:

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

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to make requests using the entities.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
