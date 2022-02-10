FROM ruby:3.1.0

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

# Create a Rails directory
WORKDIR /wordle_maker_api

# Copy source files
COPY . /wordle_maker_api

# Install gems
RUN bundle install --without production

