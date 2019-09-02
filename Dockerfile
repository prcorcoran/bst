FROM ruby:2.1.5

RUN apt-get update && \
    apt-get install -y \
    nodejs --no-install-recommends \
    sudo \
    vim \
    dnsutils \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /app
WORKDIR /tmp

COPY Gemfile Gemfile.lock /tmp/
RUN gem install bundler -v 1.15.1 && bundle _1.15.1_ install --jobs 20

ADD . /app

# Precompile Rails assets
WORKDIR /app
RUN bundle exec rake assets:precompile

CMD ["rails", "server", "-b", "0.0.0.0"]

