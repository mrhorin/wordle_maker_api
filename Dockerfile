FROM ruby:3.1.0
ENV LANG C.UTF-8

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev vim

# Create a Rails directory
WORKDIR /wordle_maker_api

# Copy source files
COPY . /wordle_maker_api

# Install gems
RUN bundle install --without production

# Prevent an error: 'manpath can't set the locale make sure $lc_* and $lang are correct'
RUN sed -i "s|SendEnv LANG LC_*|#SendEnv LANG LC_*|g" /etc/ssh/ssh_config