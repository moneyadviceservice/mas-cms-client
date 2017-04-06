#!/bin/bash -l

set -e -x

export RAILS_ENV=build
export BUNDLE_WITHOUT="development:test"

CI_PIPELINE_COUNTER=${GO_PIPELINE_LABEL-0}
CI_EXECUTOR_NUMBER=${EXECUTOR_NUMBER-0}

./bin/setup

gem build mas-cms-client.gemspec

