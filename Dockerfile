FROM ubuntu:jammy
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ENV DEBIAN_FRONTEND=noninteractive

# install essential packages, repos, Node.js, Yarn and Google Chrome
RUN apt update && apt install -y --no-install-recommends \
    curl \
    gpg-agent \
    software-properties-common \
  && curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n | bash -s 15 \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && LC_ALL=en_US.UTF-8 add-apt-repository -y ppa:ondrej/php \
  && apt update && apt install -y --no-install-recommends \
    git \
    nodejs \
    xvfb \
    yarn \
  && curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
  && apt install -y ./google-chrome-stable_current_amd64.deb \
  && rm google-chrome-stable_current_amd64.deb \
  && apt autoremove && apt clean \
  # smoke tests
  && node --version \
  && npm --version \
  && yarn --version

# install PHP and Composer
ENV PHP_VERSION 8.2.28-*
RUN apt update && apt install -y --no-install-recommends \
    php8.2-bcmath=$PHP_VERSION \
    php8.2-curl=$PHP_VERSION \
    php8.2-fpm=$PHP_VERSION \
    php8.2-gd=$PHP_VERSION \
    php8.2-intl=$PHP_VERSION \
    php8.2-mbstring=$PHP_VERSION \
    php8.2-mysql=$PHP_VERSION \
    php8.2-redis=6.* \
    php8.2-sqlite3=$PHP_VERSION \
    php8.2-xml=$PHP_VERSION \
    php8.2-zip=$PHP_VERSION \
  && apt autoremove && apt clean \
  && curl -sS https://getcomposer.org/installer | php -- \
    --install-dir=/usr/local/bin --filename=composer \
  # smoke tests
  && [[ $(php --version) == *"PHP 8.2"* ]] \
  && php --ri redis \
  && composer --version
