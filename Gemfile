source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.3'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1', '>= 1.1.3'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

gem 'rails_admin', '~> 1.4', '>= 1.4.2'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'figaro', '~> 1.1.1'
gem 'jbuilder', '~> 2.7.0'
gem 'pry-rails', '~> 0.3.6'
#gem 'oj', '~> 2.17.5'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

gem 'devise', '~> 4.4.3'
gem 'devise_token_auth', '~> 0.1.43'
gem 'geokit-rails', '~> 2.3', '>= 2.3.1'
gem 'koala', '~> 3.0'
gem 'carrierwave', '~> 1.2', '>= 1.2.3'
gem 'carrierwave-base64', '~> 2.7'
gem 'mini_magick', '~> 4.9', '>= 4.9.2'
gem 'fog-aws', '~> 3.3'
gem 'one_signal', '~> 1.2'
gem 'delayed_job_active_record', '~> 4.1', '>= 4.1.3'
gem 'sendgrid', '~> 1.2', '>= 1.2.4'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'factory_bot_rails', '~> 4.8.2'
  gem 'rspec-rails', '~> 3.8.0'
  gem 'rspec-json_expectations', '~> 2.1.0'
  gem 'faker', '~> 1.7.3'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'annotate', '~> 2.6.5'
  gem 'rails_best_practices', '~> 1.19.0'
  gem 'reek', '~> 5.0', '>= 5.0.2'
  gem 'rubocop', '~> 0.58.0'
  gem 'letter_opener', '~> 1.6'
end

group :test do
  gem 'database_cleaner', '~> 1.4.1'
  gem 'shoulda-matchers', '~> 3.1.1'
  gem 'simplecov', '~> 0.13.0', require: false
  gem 'action-cable-testing', '~> 0.3.2'
  gem 'webmock', '~> 3.4', '>= 3.4.2'
end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
