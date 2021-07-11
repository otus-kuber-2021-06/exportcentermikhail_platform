FROM nginx:1.21.0
ARG nginx_uid=1001
ARG nginx_gid=1001
RUN usermod -u 1001 nginx && groupmod -g 1001 nginx && mkdir /app && chown -R nginx /var/cache/nginx
COPY nginx.conf /etc/nginx/
COPY index.html /app
WORKDIR /app
USER 1001
EXPOSE 8000
CMD ["nginx", "-g", "daemon off;"]