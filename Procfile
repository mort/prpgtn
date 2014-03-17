web: bundle exec rails server thin -p 3000
worker: bundle exec sidekiq -q mailer,1 -q critical,2 -q default
redis: redis-server /usr/local/etc/redis.conf
