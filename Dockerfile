# ベースイメージとして公式のRubyイメージを使用
FROM ruby:3.1.3

# Node.jsとYarnをインストール
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs
RUN npm install -g yarn

# 必要な依存関係をインストール
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

# アプリケーションディレクトリを作成
RUN mkdir /myapp
WORKDIR /myapp

# 環境変数を設定
ENV NODE_OPTIONS=--openssl-legacy-provider

# GemfileとGemfile.lockをコピー
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

# Bundlerをインストールして依存関係をインストール
RUN gem install bundler -v 2.5.6
RUN bundle install

# パッケージマネージャの依存関係をインストール
COPY package.json yarn.lock ./
RUN yarn install

# アプリケーションコードをコピー
COPY . /myapp

# Webpackerのインストールとプリコンパイル
RUN bundle exec rake webpacker:install
RUN bundle exec rake assets:precompile

# サーバーを起動
CMD ["rails", "server", "-b", "0.0.0.0"]
