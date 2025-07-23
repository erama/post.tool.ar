FROM php:8.4-fpm

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y \
    nginx \
    git \
    curl \
    zip \
    unzip \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    libssl-dev \
    libwebp-dev \
    libxpm-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
        pdo_mysql \
        mbstring \
        openssl \
        tokenizer \
        xml \
        ctype \
        json \
        bcmath \
        gd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY ./nginx.conf /etc/nginx/conf.d/default.conf