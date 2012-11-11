source 'https://rubygems.org'

# make sure this bad boy is first
gem 'rails', '~> 3.2.0'

# alphabetical order now, don't mess it up :)
gem 'application_config', :git => "git@codebasehq.com:rednovalabs/lib/app_config.git"
gem 'awesome_print'
gem 'bcrypt-ruby', '~> 3.0.0'
gem 'dalli'
gem 'jquery-rails'
gem 'mysql2'
gem 'passphrase'
gem 'state_machine'
# gem 'SyslogLogger'
gem 'uuid'
gem 'haml-rails'
gem 'twilio-ruby'
gem 'randexp'

# only needed for compiling assets, these gems will not be installed in production
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'therubyracer'
  gem 'yui-compressor', :require => 'yui/compressor'
end

# only needed for development, these gems will not be installed in production
group :development do
  gem 'thin'
  gem 'pry'
  # gem 'ruby-debug19', :require => 'ruby-debug'
end

group :test do
  gem 'faker'
  gem 'simplecov', :require => false
end
