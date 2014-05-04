web: /usr/sbin/nginx -c /opt/nginx/conf/nginx.conf
worker: /home/mario/.rbenv/shims/bundle exec sidekiq -C .config/sidekiq.yml -v -L sidekiq.log -e production
redis: redis-server /etc/redis/redis.conf
