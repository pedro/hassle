require 'rubygems'
require 'spec'
require 'rack/test'

require File.dirname(__FILE__) + '/../lib/hassle'

SASS_OPTIONS = Sass::Plugin.options.dup

def write_sass(location, css_file = "screen")
  FileUtils.mkdir_p(location)
  sass_path = File.join(location, "#{css_file}.sass")
  File.open(sass_path, "w") do |f|
    f.write <<EOF
%h1
  font-size: 42em
EOF
  end

  File.join(@hassle.css_location(location), "#{css_file}.css") if @hassle
end

def be_compiled
  simple_matcher("exist") { |given| File.exists?(given) }
  simple_matcher("contain compiled sass") { |given| File.read(given) =~ /h1 \{/ }
end

def have_tmp_dir_removed(*stylesheets)
  simple_matcher("remove tmp dir") do |given|
    given == stylesheets.map { |css| css.gsub(File.join(Dir.pwd, "tmp", "hassle"), "") }
  end
end

def have_served_sass
  simple_matcher("return success") { |given| given.status == 200 }
  simple_matcher("compiled sass") { |given| given.body.should =~ /h1 \{/ }
end

def reset
  Sass::Plugin.options.clear
  Sass::Plugin.options = SASS_OPTIONS
  FileUtils.rm_rf([File.join(Dir.pwd, "public"), File.join(Dir.pwd, "tmp")])
end
