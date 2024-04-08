###############################################################
# base - dependencies required both at runtime and build time #
###############################################################
FROM ruby:3.3.0-alpine3.19 as base
MAINTAINER CeeBeeUK

RUN set -ex
RUN apk add --update --no-cache \
    postgresql-dev \
    nodejs \
    yarn \
    gcompat \
    linux-headers \
    bash

# Ensure everything is executable
RUN chmod +x /usr/local/bin/*

######################################################################
# dependencies - build dependencies using build-time os dependencies #
######################################################################
FROM base AS dependencies

# system dependencies required to build some gems
# build-base: dependencies for bundle
# git: for bundler
RUN apk add --update \
    build-base \
    libxml2-dev \
    libxslt-dev \
    libpq-dev \
    git \
    curl


COPY Gemfile Gemfile.lock .ruby-version ./
RUN gem install bundler -v $(cat Gemfile.lock | tail -1 | tr -d " ") 
RUN gem install nokogiri -- --use-system-libraries
RUN bundler -v && \
    bundle config set frozen 'true' && \
    bundle config set no-cache 'true' && \
    bundle config set no-binstubs 'true' && \
    bundle config set without test:development && \
    bundle install --jobs 5 --retry 5 && \
    rm -rf /usr/local/bundle/cache

# install npm packages
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile --check-files --ignore-scripts

# cleanup to save space in the image
RUN rm -rf log/* tmp/* /tmp && \
    rm -rf /usr/local/bundle/cache && \
    rm -rf .env && \
    find /usr/local/bundle/gems -name "*.c" -delete && \
    find /usr/local/bundle/gems -name "*.h" -delete && \
    find /usr/local/bundle/gems -name "*.o" -delete && \
    find /usr/local/bundle/gems -name "*.html" -delete
 

############################################
# production - build and use runtime image #
############################################
FROM base AS production

# add non-root user and group with alpine first available uid, 1000
RUN addgroup -g 1000 -S appgroup \
&& adduser -u 1000 -S appuser -G appgroup

# create app directory in conventional, existing dir /usr/src
RUN mkdir -p /usr/src/app && \
    mkdir -p /usr/src/app/log && \
    mkdir -p /usr/src/app/tmp && \
    mkdir -p /usr/src/app/tmp/pids

WORKDIR /usr/src/app

ENV RAILS_ENV production
ENV NODE_ENV production
ENV RAILS_SERVE_STATIC_FILES true


# libpq: required to run postgres
RUN apk add --no-cache libpq

# copy over files generated in the dependencies image
COPY --from=dependencies /usr/local/bundle/ /usr/local/bundle/
COPY --from=dependencies /node_modules/ node_modules/

# copy remaining files (except what is defined in .dockerignore)
COPY . .

RUN bundle exec rake webpacker:compile SECRET_KEY_BASE=a-real-secret-key-is-not-needed-here NODE_OPTIONS=--openssl-legacy-provider

# non-root user should own these directories
# log: for log file writing
# tmp: for pids and other things
# db: for schema migration being run on entry, at least
RUN chown -R appuser:appgroup log tmp db docker

# expect ping environment variables
ARG COMMIT_ID
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
