FROM ruby:2.3.7

RUN mkdir /app

ARG BUNDLE_OPTIONS

# see update.sh for why all "apt-get install"s have to stay as one long line
RUN apt-get update && apt-get install -y nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/*

# see http://guides.rubyonrails.org/command_line.html#rails-dbconsole
RUN apt-get update && apt-get install -y mysql-client postgresql-client sqlite3 --no-install-recommends && rm -rf /var/lib/apt/lists/*
 
RUN git clone -b master https://github.com/tokai-son/Gambreum_web.git /app/Gambreum
WORKDIR /app/Gambreum

RUN rm Gemfile.lock
ADD Gemfile.lock /app/Gambreum/Gemfile.lock

RUN bundle install --path vendor/bundle

EXPOSE  3000
