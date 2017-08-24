# Docker image to run the tests in Jenkins.

FROM ubuntu:17.04
MAINTAINER development.team@moneyadviceservice.org.uk

# Install needed packages.
RUN apt-get update -q \
    && DEBIAN_FRONTEND="noninteractive" apt-get upgrade \
            -qy \
            -o Dpkg::Options::="--force-confnew" \
            --no-install-recommends \
    && DEBIAN_FRONTEND="noninteractive" apt-get install \
            -qy \
            -o Dpkg::Options::="--force-confnew" \
            --no-install-recommends \
                # add packages one per line, in alphabetical order
                build-essential \
                git \
                ruby \
                ruby-dev \
                ruby-bundler \
    && apt-get autoremove -q \
    && apt-get clean -qy \
    && rm -rf /var/lib/apt/lists/* \
    && rm -f /var/cache/apt/*.bin

# Install the ruby and node dependencies.
# This caches them in the docker image, provided the spec files do not
# change, so the test script will execute much faster.
RUN mkdir -p /var/tmp/gem
COPY Gemfile mas-cms-client.gemspec /var/tmp/gem/
RUN mkdir -p /var/tmp/gem/lib/mas/cms/client
COPY lib/mas/cms/client/version.rb /var/tmp/gem/lib/mas/cms/client/

WORKDIR /var/tmp/gem
RUN bundle install
