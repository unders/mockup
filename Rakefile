# -*- encoding: utf-8 -*-
$:.unshift File.expand_path("../lib", __FILE__)

require 'rubygems'
require 'rubygems/specification'
require 'mockup'


def gemspec
  @gemspec ||= begin
    file = File.expand_path('../mockup.gemspec', __FILE__)
    eval(File.read(file), binding, file)
  end
end


require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
  spec.spec_opts  = %w(-fs --color)
  spec.ruby_opts  = %w(-w)
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern    = 'spec/**/*_spec.rb'
  spec.rcov_opts  = ["--sort coverage",  
                     "--profile",
                     "--rails",
                     "--exclude /gems/,/Library/,spec"]
  spec.rcov = true
end

task :spec    => :check_dependencies


begin
  require 'reek/adapters/rake_task'
  Reek::RakeTask.new do |t|
    t.fail_on_error = true
    t.verbose = false
    t.source_files = 'lib/**/*.rb'
  end
rescue LoadError
  task :reek do
    abort "Reek is not available. In order to run reek, you must: sudo gem install reek"
  end
end

begin
  require 'roodi'
  require 'roodi_task'
  RoodiTask.new do |t|
    t.verbose = false
  end
rescue LoadError
  task :roodi do
    abort "Roodi is not available. In order to run roodi, you must: sudo gem install roodi"
  end
end

task :default => :spec

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end




begin
  require 'rake/gempackagetask'
rescue LoadError
  task(:gem) { $stderr.puts "'gem install rake' to package gems" }
else
  Rake::GemPackageTask.new(gemspec) do |pkg|
    pkg.gem_spec = gemspec
  end
  task :gem => [:build, :gemspec]
end



desc "Validate Gemspec"
task :gemspec do
  gemspec.validate
end

desc "Install the gem locally"
task :install => :package do
  system "gem install pkg/#{gemspec.name}-#{gemspec.version}"
end

desc "Build the gem"
task :build do
  mkdir_p "pkg"  
  system "gem build #{gemspec.name}.gemspec"
  mv "#{gemspec.full_name}.gem", "pkg"
end

desc "Install Axe"
task :install => :gem do
  system "gem install pkg/#{gemspec.full_name}.gem"
end

