# Usamos PHP 8.4 con FPM
FROM php:8.4-fpm

# Instalar paquetes del sistema y extensiones PHP requeridas por Laravel y Stackposts
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

# Instala Composer global
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copiar configuración de Nginx
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

# Establecer directorio de trabajo
WORKDIR /var/www/html

# Copiar código completo de Stackposts
COPY . .

# Instalar dependencias PHP
RUN composer install --prefer-dist --no-dev --optimize-autoloader

# Permisos para Laravel
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Exponer puertos FPM y Nginx (si usás contenedor único con Nginx)
EXPOSE 9000 80

# Iniciar servicios PHP-FPM y Nginx en primer plano
CMD ["bash", "-c", "php-fpm & nginx -g 'daemon off;'"]
