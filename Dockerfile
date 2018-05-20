FROM nginx:1.10
	
	ADD ./config/vhost.conf /etc/nginx/conf.d/default.conf
	WORKDIR /var/www

# Timezone
ENV TIMEZONE America/Sao_Paulo
ENV PHP_MEMORY_LIMIT 512M
ENV MAX_UPLOAD 50M
ENV PHP_MAX_FILE_UPLOAD 200
ENV PHP_MAX_POST 100M
