$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))      

# Require Ruby Standard Libs
libraries = %w(fileutils date ostruct optparse )
libraries.each { |lib| require lib }


base = File.expand_path(File.dirname(__FILE__))

# Require Class Extentions
Dir[File.join(File.join(base, 'core_ext'), '*.rb')].each { |file| require file }

# Require files
require File.join(base, 'mockup/version')
require File.join(base, 'mockup/options')
require File.join(base, 'mockup/project')