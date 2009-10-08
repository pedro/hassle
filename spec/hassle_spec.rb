require File.join(File.dirname(__FILE__), "base")

describe Hassle do
	before do
    @hassle = Hassle.new
	end

  it "uses the current tmp directory by default" do
    @hassle.css_location.should == File.join(Dir.pwd, "tmp", "hassle")
  end

  it "can compile sass into tmp directory with default settings" do
    default_location = Sass::Plugin.options[:css_location]
    FileUtils.mkdir_p(File.join(default_location, "sass"))
    sass_path = File.join(default_location, "sass", "screen.sass")
    File.open(sass_path, "w") do |f|
      f.write <<EOF
%h1
  font-size: 42em
EOF
    end

    @hassle.compile

    compiled_path = File.join(@hassle.css_location, "screen.css")
    File.exists?(compiled_path).should be_true
    File.read(compiled_path).should match(/h1 \{/)
  end
end
