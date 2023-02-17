FROM nginx:1.17.0-alpine

RUN apk update && apk upgrade && apk add --update openssl
ARG LOCATION=local
ADD ./container/web/conf.d/default_${LOCATION}.conf /etc/nginx/conf.d/default.conf
ADD ./container/web/conf.d/.htpasswd /etc/nginx/conf.d/.htpasswd
ADD ./public /user/share/nginx/html

CMD nginx -g 'daemon off;'
