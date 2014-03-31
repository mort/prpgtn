web: bundle exec rails server thin -p 3000
worker: bundle exec sidekiq -v -q mailer,1 -q url_processor,2 -q default
redis: redis-server /usr/local/etc/redis.conf
