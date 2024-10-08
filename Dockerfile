FROM ruby:3.3

WORKDIR /app

COPY . .

RUN rm config.yaml
RUN bundle install

CMD bundle exec ruby src/catbot.rb

LABEL org.opencontainers.image.source "https://github.com/samsimpson1/catbot"