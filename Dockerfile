# FROM php:7.3 as php

# RUN apt-get update -y
# RUN apt-get install -y unzip libpq-dev libcurl4-gnutls-dev
# RUN docker-php-ext-install pdo pdo_mysql bcmath

# WORKDIR /var/www
# COPY . .

# COPY --from=composer:2.3.5 /usr/bin/composer /usr/bin/composer

# ENV PORT=8000

# # ENTRYPOINT [ "php","artisan","serve" ]
# # ENTRYPOINT [ "Docker/entrypoint.sh" ]

FROM php:8.2

# Arguments defined in docker-compose.yml
ARG user
ARG uid

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create system user to run Composer and Artisan Commands
# RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN useradd -G www-data,root -u 1000 -d /home/vishwaas vishwaas

RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# Set working directory
WORKDIR /Laravel_App

USER $user
COPY . .

EXPOSE 8000

ENTRYPOINT [ "Docker/entrypoint.sh" ]
