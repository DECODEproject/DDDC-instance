# Decidim Application Dockerfile
#
# This is an image to be used with docker-compose, to develop Decidim (https://decidim.org) locally.
#
#

# Starts with a clean ruby image from Debian (slim)
FROM ruby:2.5.3

# Installs system dependencies
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    imagemagick

# Bleeding edge, I have some doubts with Alpine and glibc
##
## Starts with a clean ruby image from Alpine Linux
#FROM ruby:2.5.3-alpine
#
## Installs system dependencies
#RUN apk add --update --no-cache \
#    build-base \
#    file \
#    imagemagick \
#    libc6-compat \
#    nodejs \
#    postgresql-dev \
#    tzdata \
#    xz-libs

# Sets workdir as /app
RUN mkdir /app
WORKDIR /app

# Installs bundler dependencies
ENV BUNDLE_PATH=/app/vendor/bundle \
  BUNDLE_BIN=/app/vendor/bundle/bin \
  BUNDLE_JOBS=5 \
  BUNDLE_RETRY=3 \
  GEM_HOME=/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
# Specific por DDDC/decode
ADD decidim-petitions/ /app/decidim-petitions
RUN bundle install

# Copy all the code to /app
ADD . /app
