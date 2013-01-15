web: bundle exec rails server thin -p $PORT
worker: bundle exec rake resque:work QUEUE='*' WORKERS=5 
redis: redis-server /usr/local/etc/redis.conf

