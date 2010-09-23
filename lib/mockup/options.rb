module Mockup
  class Options
    
    def self.parse(args)
      options = OpenStruct.new
      
      opts = ::OptionParser.new do |opts|
        opts.on('-l', '--location LOCATION', 'The directory location you want your mockup to be created in. This defaults to the current working directory.') do |location|
          options.location = location
        end
        
        opts.on_tail("-h", "--help", "Help Screen") do
          puts opts
          exit
        end

        opts.on_tail("-v", "--version", "Show version") do
          puts "Mockup is currently at version #{::Mockup.version}"
          exit
        end
      end
      
      
      opts.parse!(args)
      options
    end
    
  end
end