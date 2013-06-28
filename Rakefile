begin
  require 'ant'
rescue
  puts("ERROR: unable to load Ant, make sure Ant is installed, in your PATH and $ANT_HOME is defined properly")
  puts("\nerror detail:\n#{$!}")
  exit(1)
end

require 'jruby/jrubyc'

desc "compile Java classes"
task :compile do
  ant.path 'id' => 'classpath' do
    fileset 'dir' => "target/dependency/storm/default"
  end

  options = {
    'srcdir' => "src",
    'destdir' => "target/classes",
    'classpathref' => 'classpath',
    'debug' => "yes",
    'includeantruntime' => "no",
    'verbose' => false,
    'listfiles' => true,
  }
  ant.javac(options)
end

desc "intall RedStorm"
task :install do
  system("bundle exec redstorm install")
end

desc "create RedStorm topology jar"
task :jar do
  system("bundle exec redstorm jar lib")
end

desc "initial setup"
task :setup => [:install, :compile, :jar] do
end

task :default => :setup
