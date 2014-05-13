#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

begin
  require 'rdoc/task'
rescue LoadError
  require 'rdoc/rdoc'
  require 'rake/rdoctask'
  RDoc::Task = Rake::RDocTask
end

desc 'Generate documentation for Alchemy CMS.'
RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Alchemy CMS'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.md')
  rdoc.rdoc_files.include('config/alchemy/*.yml')
  rdoc.rdoc_files.include('lib/**/*.rb')
  rdoc.rdoc_files.include('app/**/*.rb')
end

APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'

require 'rspec/core'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => ['alchemy:spec:prepare', :spec]

Bundler::GemHelper.install_tasks

namespace :alchemy do
  namespace :spec do

    desc "Prepares database for testing Alchemy"
    task :prepare do
      system 'cd spec/dummy && RAILS_ENV=test bundle exec rake db:drop db:create db:migrate:reset && cd -'
    end

  end

  namespace :i18n do

    desc "Updates translation files with latest keys from German translation"
    task :sync do
      puts "Starting syncronization..."
      file = File.expand_path("../config/locales/alchemy.de.yml", __FILE__)
      data = YAML.load_file(file)['de']['alchemy']
      Alchemy::I18n.available_locales.each do |locale|
        next if locale == 'de'
        puts "Updating #{locale} locale file"
        old_file = File.expand_path("../config/locales/alchemy.#{locale}.yml", __FILE__)
        old_data = YAML.load_file(old_file)
        data.each do |key, value|
          next if old_data[locale]['alchemy'][key].present?
          if key.to_s.match /_/
            new_key = key.to_s.humanize
          else
            new_key = key
          end
          old_data[locale]['alchemy'][key] = new_key
        end
        File.new("./config/locales/alchemy.#{locale}.yml", 'w') << old_data.to_yaml
      end
      puts "Done."
    end

  end
end
