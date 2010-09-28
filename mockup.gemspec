# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'mockup/version'
    
Gem::Specification.new do |gem|
  gem.name              = 'mockup'
  gem.version           = Mockup.version
  gem.date              = '2010-09-23'
  gem.platform          = Gem::Platform::RUBY

  gem.add_dependency              'serve',    '~> 0.11.7'
  gem.add_development_dependency  'rspec',    '~> 1.3.0'

  gem.summary           = "summary"
  gem.description       = "Longer description."

  gem.authors           = ['Robert R Evans']
  gem.email             = ['robert@codewranglers.org']
  gem.homepage          = 'http://github.com/revans/mockup'

  gem.rubyforge_project = nil

  gem.files             = Dir.glob("{bin,lib}/**/*") + %w(LICENSE README.textile Rakefile build.version)
  gem.executables       = ['mockup']
  gem.require_path      = 'lib'
end
