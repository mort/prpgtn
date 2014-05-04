web: bundle exec puma -t ${PUMA_MIN_THREADS:-8}:${PUMA_MAX_THREADS:-12} -w ${PUMA_WORKERS:-2} -p ${PORT:-3000} -e ${RACK_ENV:-development}
worker: bundle exec sidekiq -v 
redis: redis-server /usr/local/etc/redis.conf
