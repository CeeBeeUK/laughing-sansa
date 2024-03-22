FROM ruby:3.2.1-alpine3.17 as base
MAINTAINER CeeBeeUK

RUN set -ex
# build dependencies:
# - virtual: create virtual package for later deletion
# - build-base for alpine fundamentals
# - libxml2-dev/libxslt-dev for nokogiri, at least
# - postgresql-dev for pg/activerecord gems
# - git for installing gems referred to use a git:// uri
#
RUN apk --no-cache add --virtual build-dependencies \
                    build-base \
                    libxml2-dev \
                    libxslt-dev \
                    postgresql-dev \
                    git \
                    curl \
&& apk --no-cache add \
                  postgresql-client \
                  nodejs \
                  yarn \
                  jq \
                  linux-headers \
                  bash

# Ensure everything is executable
RUN chmod +x /usr/local/bin/*

# add non-root user and group with alpine first available uid, 1000
RUN addgroup -g 1000 -S appgroup \
&& adduser -u 1000 -S appuser -G appgroup

# create app directory in conventional, existing dir /usr/src
RUN mkdir -p /usr/src/app && mkdir -p /usr/src/app/tmp
WORKDIR /usr/src/app

######################
# DEPENDENCIES START #
######################
# Env vars needed for dependency install and asset precompilation
COPY Gemfile* ./
# only install production dependencies,
# build nokogiri using libxml2-dev, libxslt-dev
RUN gem install bundler -v 2.0.2 \
&& bundle config --global without test:development \
&& bundle config build.nokogiri --use-system-libraries \
&& bundle install
COPY package.json yarn.lock ./
RUN yarn --prod
####################
# DEPENDENCIES END #
####################
ENV RAILS_ENV production
ENV NODE_ENV production
ENV RAILS_SERVE_STATIC_FILES true
EXPOSE 3002
COPY . .
RUN bundle exec rake webpacker:compile SECRET_KEY_BASE=a-real-secret-key-is-not-needed-here NODE_OPTIONS=--openssl-legacy-provider
# tidy up installation
RUN apk del build-dependencies
# non-root/appuser should own only what they need to
RUN chown -R appuser:appgroup log tmp db
# expect ping environment variablesARG COMMIT_ID
ARG BUILD_DATE
ARG BUILD_TAG
ARG APP_BRANCH
# set ping environment variables
ENV BUILD_DATE=${BUILD_DATE}
ENV BUILD_TAG=${BUILD_TAG}
ENV APP_BRANCH=${APP_BRANCH}

# switch to non-root user
USER 1000

# set port env var used by puma
ENV PORT 3000
EXPOSE $PORT

ENTRYPOINT ["./docker/entrypoint"]
