#!/bin/bash -l

set -e -x

export PATH=./bin:$PATH

./bin/setup

CI_PIPELINE_COUNTER=${GO_PIPELINE_LABEL-0}
CI_EXECUTOR_NUMBER=${EXECUTOR_NUMBER-0}

bundle exec rspec
