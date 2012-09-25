
# ~ operator
# ----------
#
# The operator will drop the final digit of a version,
# then increment the remaining final digit to get the upper limit version number.
# Therefore ‘~> 2.2’ is equivalent to: [‘>= 2.2’, ‘< 3.0’].
# Had we said ‘~> 2.2.0’, it would have been equivalent to: [‘>= 2.2.0’, ‘< 2.3.0’].
#
#   From http://docs.rubygems.org/read/chapter/16

source 'http://rubygems.org' # TODO: https, http://railsapps.github.com/openssl-certificate-verify-failed.html

gem 'rails', '~> 3.2.0' # MIT
  # Bundle edge Rails instead:
  # gem 'rails', :git => 'git://github.com/rails/rails.git'


# Gems used only for assets and not required in production environments by default.
group :assets do
  gem 'sass-rails' # MIT
  gem 'coffee-rails' # MIT

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer' # MIT

  gem 'uglifier' # MIT
  gem 'font-awesome-sass-rails' # The font and SCSS from Font Awesome are under CC-BY-3.0, others are under MIT license.
end


# Gems used only for development and not required in production environments by default.
group :development do
  # Pretty print
  gem 'awesome_print' # MIT

  # That solves "Could not determine content-length of response body" message appereance in logs
  gem 'webrick', '>= 1.3.1' # Ruby

  # Debugger, compartible with 1.9.3, https://github.com/cldwalker/debugger
  gem 'debugger' # 2-clause BSD
end


# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'


# Automate using jQuery with Rails 3
gem 'jquery-rails' # MIT

# Use unicorn as the app server
gem 'unicorn' # Ruby

# PostgreSQL database access
gem 'pg' # Ruby

# Exception handling
gem 'exceptional' # MIT

# Templating
gem 'slim' # MIT

# Client-side time ago calculation using jQuery Timeago plugin
gem 'rails-timeago' # MIT

# File uploads handling
gem 'carrierwave' # MIT

# A ruby wrapper for ImageMagick or GraphicsMagick command line.
gem 'mini_magick' # MIT

# Additional processing support for MiniMagick and RMagick.
gem 'carrierwave-processing' # MIT

# JSON
gem 'oj' # 3-clause BSD
