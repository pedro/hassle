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

  File.join(@hassle.css_location, "#{css_file}.css")
end

def be_compiled
  simple_matcher("exist") { |given| File.exists?(given) }
  simple_matcher("contain compiled sass") { |given| File.read(given) =~ /h1 \{/ }
end


