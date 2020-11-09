FROM ruby:alpine

ENV APP_HOME=/app COMMENT_DATABASE_HOST=comment_db COMMENT_DATABASE=comments
WORKDIR $APP_HOME

COPY . $APP_HOME
RUN apk add --no-cache --virtual ruby-dev build-base && gem install bundler:1.17.2 && bundle install && apk del build-base ruby-dev

CMD ["puma"]
