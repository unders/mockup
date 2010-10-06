module Mockup
  class Project
    class << self
      
      attr_reader :location, :full_name, :name
      
      def create(options)
        @name       = options.name || 'mockup'
        @location   = options.location ? File.join(File.expand_path(options.location), @name.underscore) : File.join(Dir.pwd, @name.underscore)
        @full_name  = git_config('user.name')   || 'Your Full Name'
        
        setup_base_project
        
        FileUtils.mkdir_p(File.join(@location, 'sass'))
        FileUtils.mkdir_p(File.join(@location, 'public/images'))
        FileUtils.mkdir_p(File.join(@location, 'public/stylesheets'))
        File.open(File.join(@location, "compass.config"), 'w+') { |f| f.puts compass_config }
        

        install_javascript(options)
      end
      
      
      def setup_base_project
        FileUtils.mkdir_p(File.join(@location, 'public'))
        FileUtils.mkdir_p(File.join(@location, 'tmp'))
        FileUtils.mkdir_p(File.join(@location, 'views/layouts'))

        FileUtils.touch(File.join(@location, 'README.mk'))
        FileUtils.touch(File.join(@location, 'tmp/restart.txt'))
        
        File.open(File.join(@location, "config.ru"), 'w+')      { |f| f.puts config_ru }
        
        File.open(File.join(@location, "LICENSE"), 'w+')      { |f| f.puts license }
        File.open(File.join(@location, ".gitignore"), 'w+')   { |f| f.puts gitignore }
      end
      
      
      
      
      
      def convert(options)
        @location   = options.location ? File.join(File.expand_path(options.location)) : Dir.pwd
        @full_name  = git_config('user.name') || 'Your Full Name'
        setup_base_project
        
        # Move Compass files that were created.

        FileUtils.mv(File.join(@location, 'images'),      File.join(@location, 'public/')) if File.exists?(File.join(@location, 'images'))
        FileUtils.mv(File.join(@location, 'stylesheets'), File.join(@location, 'public/')) if File.exists?(File.join(@location, 'stylesheets'))
        FileUtils.mv(File.join(@location, 'javascripts'), File.join(@location, 'public/')) if File.exists?(File.join(@location, 'javascripts'))
        
        # Move default src (from compass create) to sass
        FileUtils.mv(File.join(@location, 'src'), File.join(@location, 'sass'))
        # FileUtils.cp(File.join(@location, 'config.rb'), File.join(@location, 'compass.config'))
        
        File.open(File.join(@location, "compass.config"), 'w+') { |f| f.puts compass_config }
        install_javascript(options)
      end


      
      
      
      
      def license
        <<-LICENSE
Copyright (c) #{Time.now.year} #{@full_name}

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

        LICENSE
      end
      
      def compass_config
        <<-COMPASS_CONFIG
http_path             = '/'
http_stylesheets_path = '/stylesheets'
http_images_path      = '/images'
http_javascripts_path = '/javascripts'

sass_dir              = 'sass'
css_dir               = 'public/stylesheets'
images_dir            = 'public/images'
javascripts_dir       = 'public/javascripts'

relative_assets       = true
        
        COMPASS_CONFIG
      end
      
      
      def config_ru
        <<-CONFIG_RU
gem 'activesupport'
gem 'serve',  '~> 0.11.7'

require 'serve'
require 'serve/rack'

require 'sass/plugin/rack'
require 'compass'

# The project root directory
root = ::File.dirname(__FILE__)

# Compass
Compass.add_project_configuration(root + '/compass.config')
Compass.configure_sass_plugin!

# Rack Middleware
use Rack::ShowStatus      # Nice looking 404s and other messages
use Rack::ShowExceptions  # Nice looking errors
use Sass::Plugin::Rack    # Compile Sass on the fly

# Rack Application
if ENV['SERVER_SOFTWARE'] =~ /passenger/i
  # Passendger only needs the adapter
  run Serve::RackAdapter.new(root + '/views')
else
  # We use Rack::Cascade and Rack::Directory on other platforms to handle static 
  # assets
  run Rack::Cascade.new([
    Serve::RackAdapter.new(root + '/views'),
    Rack::Directory.new(root + '/public')
  ])
end
        CONFIG_RU
      end
      
      
      def gitignore
        <<-IGNORE
## MAC OS
.DS_Store

## TEXTMATE
*.tmproj
tmtags

## EMACS
*~
\#*
.\#*

## VIM
*.swp

## PROJECT::GENERAL
coverage
rdoc
pkg

## PROJECT::SPECIFIC
*.gem
        IGNORE
      end
      
      def install_javascript(options)
        install_jquery      if options.jquery
        install_mootools    if options.mootools
        install_prototype   if options.prototype
      end
      
      
      def install_jquery
        get_javascript_file('jquery',     'http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js')
        get_javascript_file('jquery_ui',  'http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.5/jquery-ui.min.js')
      end
      

      def install_mootools
        get_javascript_file('mootools', 'http://ajax.googleapis.com/ajax/libs/mootools/1.2.4/mootools-yui-compressed.js')
      end
      
      
      def install_prototype
        get_javascript_file('prototype', 'http://ajax.googleapis.com/ajax/libs/prototype/1.6.1.0/prototype.js')
        get_javascript_file('scriptaculous', 'http://ajax.googleapis.com/ajax/libs/scriptaculous/1.8.3/scriptaculous.js')
      end

      
      
      def get_javascript_file(name, path)
        create_javascript_dir
        filename = File.join(@location, "public/javascripts/#{name}.js")
        `curl -o #{filename} #{path}`
      end
      
      
      def create_javascript_dir
        FileUtils.mkdir_p(File.join(@location, 'public/javascripts')) unless File.exists?(File.join(@location, 'javascripts'))
        FileUtils.touch(File.join(@location, 'public/javascripts/application.js'))
      end
      
      
      private

        def git_config(key)
          value = `git config #{key}`.chomp
          value.empty? ? nil : value
        end
      
    end
  end
end