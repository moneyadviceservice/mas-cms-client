# Mas::Cms::Client

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mas-cms-client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mas-cms-client

## Usage

In order to setup the gem to your application you need to provide
some informations about the request and the cms location:

```
  Mas::Cms::Client.config do |mas_cms_client|
    mas_cms_client.timeout = 10
    mas_cms_client.host = 'http://cms.mas/'
  end
```
