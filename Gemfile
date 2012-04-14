
# http://docs.rubygems.org/read/chapter/16
#
# The operator will drop the final digit of a version,
# then increment the remaining final digit to get the upper limit version number.
# Therefore ‘~> 2.2’ is equivalent to: [‘>= 2.2’, ‘< 3.0’].
# Had we said ‘~> 2.2.0’, it would have been equivalent to: [‘>= 2.2.0’, ‘< 2.3.0’].
# The last digit specifies the level of granularity of version control

source 'https://rubygems.org'

gem 'rails', '3.2.2' # MIT

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# gem 'sqlite3'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3' # MIT
  gem 'coffee-rails', '~> 3.2.1' # MIT

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer' # MIT

  gem 'uglifier', '>= 1.0.3' # MIT
end

gem 'jquery-rails' # MIT

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
gem 'unicorn' # Ruby

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

gem 'pg' # Ruby
gem 'exceptional' # MIT
gem 'slim' # MIT

group :development do
  gem 'slim-rails' # MIT
end

# TODO: Take a look
# https://github.com/ctran/annotate_models # Ruby
