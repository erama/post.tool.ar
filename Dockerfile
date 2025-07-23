FROM php:8.4-fpm

# Variables necesarias
ENV APP_ENV=production
ENV APP_KEY=
ENV APP_DEBUG=false

# Instalar dependencias
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
        openssl \
        tokenizer \
        xml \
        ctype \
        json \
        bcmath \
        gd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Crear directorio de trabajo
WORKDIR /var/www/html

# Copiar archivos del proyecto
COPY . .

# Instalar dependencias Laravel
RUN composer install --no-dev --optimize-autoloader

# Asignar permisos
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 storage bootstrap/cache

# Copiar configuración de Nginx
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

# Generar key de Laravel y correr migraciones
RUN php artisan config:clear && \
    php artisan cache:clear && \
    php artisan config:cache && \
    php artisan key:generate && \
    php artisan migrate --force
