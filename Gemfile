source 'https://rubygems.org'

chef_version = ENV.fetch('CHEF_VERSION', '11.16')

gem 'chef', "~> #{chef_version}"
gem 'chefspec', '~> 4.2.0' if chef_version =~ /^11/

gem 'berkshelf', '~> 3.2.1'
gem 'foodcritic', '~> 4.0.0'
gem 'rake'
gem 'rubocop', '~> 0.28.0'
gem 'serverspec', '~> 2.7.1'

group :integration do
  gem 'busser-serverspec', '~> 0.5.3'
  gem 'kitchen-vagrant', '~> 0.15.0'
  gem 'test-kitchen', '~> 1.3.1'
end
