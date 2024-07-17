# ベースイメージとして公式のRubyイメージを使用
FROM ruby:3.1.3

# 作業ディレクトリを作成
WORKDIR /myapp

# 必要な依存関係をインストール
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev curl

# Node.jsとYarnをインストール
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs
RUN npm install -g yarn

# 環境変数を設定
ENV NODE_OPTIONS=""

# GemfileとGemfile.lockをコピー
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

# Bundlerをインストールして依存関係をインストール
RUN gem install bundler -v 2.5.6
RUN bundle install

# package.jsonとyarn.lockをコピー
COPY package.json yarn.lock ./

# 依存関係をインストール
RUN yarn install

# アプリケーションコードをコピー
COPY . /myapp

# Webpackerのインストールとプリコンパイル
RUN bundle exec rake webpacker:install
RUN bundle exec rake assets:precompile

# サーバーを起動
CMD ["rails", "server", "-b", "0.0.0.0"]
