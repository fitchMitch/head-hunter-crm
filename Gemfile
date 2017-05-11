source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails',        '5.0.1'
gem 'sass-rails',   '5.0.6'
gem 'uglifier',     '3.0.0'
gem 'coffee-rails', '4.2.1'
gem 'sprockets',    '~> 3.0'
gem 'jquery-rails', '4.1.1'
gem 'jquery-ui-rails'
gem 'turbolinks',   '5.0.1'
gem 'jquery-turbolinks'
gem 'jbuilder',     '2.4.1'
gem 'bootstrap-sass', '3.3.6'
gem 'bcrypt',         '3.1.11'
gem 'faker',          '1.6.6'
gem 'will_paginate',           '3.1.0'
gem 'bootstrap-will_paginate', '0.0.10'
gem 'simple_form'
gem 'select2-rails'
gem "font-awesome-rails"
gem 'date_validator',   '~> 0.9.0'
gem 'paperclip',        "~> 5.0.0"
gem 'paperclip-i18n'
gem 'simple_calendar', '~> 2.2', '>= 2.2.5'
gem 'icalendar', '~> 2.4', '>= 2.4.1'
gem 'sqlite3', '1.3.12'
#temp



group :development, :test do
  gem 'puma',         '3.4.0'
  gem "factory_girl_rails",     "~> 4.0"
  gem 'byebug',  '9.0.0', platform: :mri
  gem 'as-duration'
end

group :development do
  gem 'web-console',           '3.1.1'
  gem 'listen',                '3.0.8'
  gem 'spring',                '1.7.2'
  gem 'spring-watcher-listen', '2.0.0'
end

group :test do
  gem 'color_pound_spec_reporter'
  gem 'rails-controller-testing', '0.1.1'
  gem 'minitest-reporters',       '1.1.9'
  gem 'guard',                    '2.13.0'
  gem 'guard-minitest',           '2.4.4'
end

group :production do
  #gem "passenger", ">= 5.0.25", require: "phusion_passenger/rack_handler"

  #gem 'pg', '0.18.4'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
