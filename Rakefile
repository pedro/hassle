require 'rake'
require 'spec/rake/spectask'

desc "Run all specs"
Spec::Rake::SpecTask.new('spec') do |t|
	t.spec_opts = ['--colour --format progress --loadby mtime --reverse']
	t.spec_files = FileList['spec/*_spec.rb']
end

task :default => :spec
