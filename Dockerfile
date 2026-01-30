FROM ruby:3.3.5

WORKDIR /app

RUN apt-get update -y \
  && apt-get install -y --no-install-recommends build-essential libsqlite3-dev \
  && rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

CMD ["bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]
