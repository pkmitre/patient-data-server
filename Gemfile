source 'http://rubygems.org'


gem 'rails', '3.2.13'
gem "health-data-standards",:git => 'https://github.com/projectcypress/health-data-standards.git', branch: 'develop'
gem "mongoid", '~> 3.1.0'

gem "capistrano", "2.13.5"
gem "nokogiri", '~> 1.5.5'
gem 'devise'

gem "json-jwt"

gem 'omniauth'
gem 'omniauth_openid_connect', :git => "https://github.com/project-rhex/omniauth_openid_connect.git"

gem 'kaminari'
gem "symbolize", :require => "symbolize/mongoid"

gem 'rest-client'

gem "typhoeus"

gem 'rmagick'
gem 'dicom'

group :assets do
  gem 'sass-rails', "  ~> 3.2.3"
  gem 'bootstrap-sass', '~> 2.3.1.0'
  gem 'coffee-rails', "~> 3.2.1"
  gem 'uglifier', ">= 1.0.3"
end

gem 'jquery-rails'

group :production do
  gem "therubyracer"
  gem 'thin'
end

group :development do
  gem "pry"
  gem 'pry-nav'
end

group :test do
  gem "pry"
  gem 'turn', :require => false
  gem "minitest", "~> 4.0"
  gem 'feedzirra'
  gem 'cover_me'
  gem 'factory_girl_rails'
  gem 'webmock'
end
