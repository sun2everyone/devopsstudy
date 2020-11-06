FROM ruby:alpine

ENV APP_HOME=/app 
WORKDIR $APP_HOME
COPY . $APP_HOME
RUN apk add --no-cache --virtual ruby-dev build-base && gem install bundler:1.17.2 && bundle install && apk del build-base ruby-dev

ENV POST_SERVICE_HOST=post POST_SERVICE_PORT=5000 COMMENT_SERVICE_HOST=comment COMMENT_SERVICE_PORT=9292

CMD ["puma"]
