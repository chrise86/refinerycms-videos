source "http://rubygems.org"

gemspec


# Lock the project to a version before some breaking changes.
#git 'git://github.com/resolve/refinerycms.git', :ref => "a82690e9a376757ca8ece27343eb96e4f07108f7" do
#  gem 'refinerycms'

#  group :development, :test do
#    gem 'refinerycms-testing'
#  end
#end

gem 'refinerycms', :git => 'git://github.com/resolve/refinerycms.git'
gem 'refinerycms-i18n', :git => 'git://github.com/parndt/refinerycms-i18n.git'


# Refinery/rails should pull in the proper versions of these
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

gem 'jquery-rails'

group :development, :test do
  gem 'factory_girl_rails'
  gem 'generator_spec'
  
  require 'rbconfig'

  platforms :jruby do
    gem 'activerecord-jdbcsqlite3-adapter'
    gem 'activerecord-jdbcmysql-adapter'
    gem 'activerecord-jdbcpostgresql-adapter'
    gem 'jruby-openssl'
  end

  unless defined?(JRUBY_VERSION)
    gem 'sqlite3'
    gem 'mysql2'
    gem 'pg'
  end

  platforms :mswin, :mingw do
    gem 'win32console'
    gem 'rb-fchange', '~> 0.0.5'
    gem 'rb-notifu', '~> 0.0.4'
  end

  platforms :ruby do
    gem 'spork'
    gem 'guard-spork', '~> 1.1.0'

    unless ENV['TRAVIS']
      if RbConfig::CONFIG['target_os'] =~ /darwin/i
        gem 'rb-fsevent', '>= 0.3.9'
        gem 'growl',      '~> 1.0.3'
      end
      if RbConfig::CONFIG['target_os'] =~ /linux/i
        gem 'rb-inotify', '~> 0.8.8'
        gem 'libnotify',  '~> 0.7.4'
        gem 'therubyracer', '~> 0.10.1'
      end
    end
  end

  platforms :jruby do
    unless ENV['TRAVIS']
      if RbConfig::CONFIG['target_os'] =~ /darwin/i
        gem 'growl',      '~> 1.0.3'
      end
      if RbConfig::CONFIG['target_os'] =~ /linux/i
        gem 'rb-inotify', '>= 0.5.1'
        gem 'libnotify',  '~> 0.1.3'
      end
    end
  end
end
