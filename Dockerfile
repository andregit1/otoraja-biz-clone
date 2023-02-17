FROM ruby:2.6.3-buster
ENV LANG C.UTF-8

RUN curl -sL https://deb.nodesource.com/setup_10.x | sed 's|https://|http://|' | bash - && apt-get update && apt-get install -y build-essential default-mysql-client nodejs openssl
RUN npm install -g yarn
RUN gem install bundler

RUN mkdir /app
WORKDIR /app

ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install --jobs 4

ADD package.json /app/package.json
ADD yarn.lock /app/yarn.lock
RUN yarn install

ADD . /app

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0", "-p", "3000"]
