web: bundle exec service nginx start
worker: bundle exec sidekiq -v -L sidekiq.log -e production
redis: redis-server etc/redis.conf
