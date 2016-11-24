source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'will_paginate'
gem 'will_paginate-bootstrap'

# Premailer for HTM/CSS mail formating
gem 'premailer-rails'

# Bootstrap-form for bootstraop styled forms
gem 'bootstrap_form', git: 'https://github.com/bootstrap-ruby/rails-bootstrap-forms.git'

# email model validator
gem 'email_validator'

# gem 'sass-rails', git: 'https://github.com/rails/sass-rails.git'
gem 'bootstrap-sass', '~> 3.2'

# Gems used only for assets and not required
# in production environments by default.
# group :assets do
  gem 'sprockets' #, '=2.11.0'
  # Use SCSS for stylesheets
  gem 'sass-rails', '~> 5.0'

  source 'https://rails-assets.org' do
    gem 'rails-assets-jquery', '~>1.9.1'
    gem 'rails-assets-jquery-ui'
    gem 'rails-assets-jquery-ujs'
    gem 'rails-assets-jquery.inview'
    gem 'rails-assets-moment'
    gem 'rails-assets-d3'
    gem 'rails-assets-spin'
    gem 'rails-assets-google-code-prettify'
    gem 'rails-assets-bowser'
  end
  gem 'summernote-rails'
#end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'dotenv-rails'
  gem 'rspec-rails', git: 'https://github.com/rspec/rspec-rails.git'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'rails-controller-testing'
end

group :development do
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
