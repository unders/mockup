module Mockup
  class Options

    def self.parse(args)
      options = OpenStruct.new
      
      ParseOptions.new(args) do |opts|

        opts.value('create') do |name|
          options.name = name
        end

        opts.boolean('convert') do |convert|
          options.convert = !!convert
        end

        opts.value('-l', '--location') do |location|
          options.location = location
        end
        
        opts.boolean('with-jquery') do |jquery|
          options.jquery = !!jquery
        end
        
        opts.boolean('with-mootools') do |mootools|
          options.mootools = !!mootools
        end
        
        opts.boolean('with-prototype') do |prototype|
          options.prototype = !!prototype
        end

        opts.help('help', '-h') do
          puts <<-HELP

Usage: mockup create name --location /path/to/mockup

Mockup Options:

create:     The name of the mockup project. 
              e.g. mockup create project
-l:         Specify a location to create your mockup project. 
              e.g. mockup create project -l /path/to/mockup
convert:    Convert an existing Compass project to a mockup project. 
              e.g. mockup convert
with-jquery Install jQuery and jQuery UI
              e.g. mockup create project with-jquery
help        View the Help Screen
version     View the current version of mockup

          HELP
          exit(0)
        end

        opts.version('-v', 'version') do
          puts "Mockup's current version is #{Mockup.version}"
          exit(0)
        end
      end
      options
    end
  end
end