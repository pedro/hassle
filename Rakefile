require 'rake'
require 'spec/rake/spectask'

desc "Run all specs"
Spec::Rake::SpecTask.new('spec') do |t|
	t.spec_opts = ['--colour --format progress --loadby mtime --reverse']
	t.spec_files = FileList['spec/*_spec.rb']
end

begin
  require 'cucumber/rake/task'

  Cucumber::Rake::Task.new(:cucumber) do |t|
    t.cucumber_opts = "--format pretty"
  end
rescue LoadError
  desc 'Cucumber rake task not available'
  task :features do
    abort 'Cucumber rake task is not available. Be sure to install cucumber as a gem or plugin'
  end
end

task :default => [:spec, :cucumber]

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "hassle"
    gem.summary = "Make SASS less of a hassle."
    gem.description = "Makes SASS less of a hassle on read-only filesystems by compiling and serving it up for you."
    gem.homepage = "http://github.com/pedro/hassle"
    gem.authors = ["Pedro Belo", "Nick Quaranto"]
    gem.files = FileList["LICENSE", "README.textile", "lib/hassle.rb", "init.rb"]
    gem.add_dependency('rack')
    gem.add_dependency('haml')
    gem.add_development_dependency('rspec')
    gem.add_development_dependency('cucumber')
    gem.add_development_dependency('rack-test')
    gem.required_rubygems_version = Gem::Requirement.new(">= 1.3.5") if gem.respond_to? :required_rubygems_version=
  end
  Jeweler::RubyforgeTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end
