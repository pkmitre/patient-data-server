source 'http://rubygems.org'


gem 'rails', '3.2.13'
gem "health-data-standards",:git => 'https://github.com/projectcypress/health-data-standards.git', branch: 'develop'
gem 'ruby-openid'
gem "mongoid", '~> 3.1.0'
gem "pry"
gem 'pry-nav'
gem "capistrano", "2.13.5"
gem "nokogiri", '~> 1.5.5'
gem 'devise'
gem 'devise_oauth2_providable', :git => 'https://github.com/project-rhex/devise_oauth2_providable.git' #,:branch => "master" 
gem 'omniauth_openid_connect', :git => "https://github.com/project-rhex/omniauth_openid_connect.git"

gem 'omniauth'
gem 'omniauth-openid'
gem 'kaminari'
gem "symbolize", :require => "symbolize/mongoid"

gem 'rmagick'
gem 'dicom'

group :assets do
  gem 'sass-rails', "  ~> 3.2.3"
  gem 'coffee-rails', "~> 3.2.1"
  gem 'uglifier', ">= 1.0.3"
end

gem 'jquery-rails'

group :production do
  gem "therubyracer"
  gem 'thin'
end


group :test do
  gem 'turn', :require => false
  gem "minitest", "~> 4.0"
  gem 'feedzirra'
  gem 'cover_me'
  gem 'factory_girl_rails'
  gem 'webmock'
end
