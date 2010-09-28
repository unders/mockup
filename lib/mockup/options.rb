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

        opts.help('help') do
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

          HELP
          exit(0)
        end

        opts.version('-v', '--version') do
          puts "Version Number 1"
          exit(0)
        end
      end
      options
    end
  end
end