port        ENV['PORT']     || 80
environment ENV['RACK_ENV'] || 'production'

web: bundle exec passenger start -p $PORT --max-pool-size 3
