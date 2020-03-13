from ruby:2.6.5

RUN gem install bundler:2.1.4

COPY . /code

WORKDIR /code

RUN cp -n config/secrets.yml.example config/secrets.yml

RUN bundle install

CMD ["rails", "s"]
