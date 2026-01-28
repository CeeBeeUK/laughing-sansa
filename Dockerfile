FROM ruby:4.0.0-alpine3.23 AS base
LABEL org.opencontainers.image.vendor="CeeBeeUK" \
      org.opencontainers.image.authors="CeeBeeUK" \
      org.opencontainers.image.title="Eurovision" \
      org.opencontainers.image.description="Public code, private party" \
      org.opencontainers.image.url="https://github.com/CeeBeeUK/laughing-sansa"

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
                    yaml-dev \
                    libpq-dev \
                    git \
                    curl \
&& apk --no-cache add \
                  postgresql-client \
                  nodejs \
                  libxslt \
                  yarn \
                  gcompat \
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
COPY .ruby-version Gemfile* ./
# only install production dependencies,
# build nokogiri using libxml2-dev, libxslt-dev
RUN gem install bundler -v $(cat Gemfile.lock | tail -1 | tr -d " ") 
RUN bundler -v && \
    bundle config set frozen 'true' && \
    bundle config set no-cache 'true' && \
    bundle config set no-binstubs 'true' && \
    bundle config set without test:development && \
    bundle config build.nokogiri --use-system-libraries && \
    bundle install --jobs 5 --retry 5 && \
    rm -rf /usr/local/bundle/cache

# install npm packages
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile --check-files --ignore-scripts

####################
# DEPENDENCIES END #
####################
ENV RAILS_ENV=production
ENV NODE_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
COPY . .
RUN bundle exec rake webpacker:compile SECRET_KEY_BASE=a-real-secret-key-is-not-needed-here NODE_OPTIONS=--openssl-legacy-provider
# tidy up installation
RUN apk del build-dependencies
# non-root/appuser should own only what they need to
RUN chown -R appuser:appgroup log tmp db docker
# expect ping environment variables
ARG BUILD_DATE
ARG BUILD_TAG
# set ping environment variables
ENV BUILD_DATE=${BUILD_DATE}
ENV BUILD_TAG=${BUILD_TAG}

# switch to non-root user
USER 1000

# set port env var used by puma
ENV PORT=3000
EXPOSE $PORT

ENTRYPOINT ["./docker/entrypoint"]
