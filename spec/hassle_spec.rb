require File.join(File.dirname(__FILE__), "base")

describe Hassle do
	before do
    @hassle = Hassle.new
	end

  it "uses the current tmp directory by default" do
    @hassle.css_location.should == File.join(Dir.pwd, "tmp", "hassle")
  end

  describe "compiling sass" do
    before do
      system("git clean -dfxq")
      default_location = Sass::Plugin.options[:css_location]
      FileUtils.mkdir_p(File.join(default_location, "sass"))
      sass_path = File.join(default_location, "sass", "screen.sass")
      File.open(sass_path, "w") do |f|
        f.write <<EOF
%h1
  font-size: 42em
EOF
      end

      @compiled_path = File.join(@hassle.css_location, "screen.css")
    end

    it "moves css into tmp directory with default settings" do
      @hassle.compile

      File.exists?(@compiled_path).should be_true
      File.read(@compiled_path).should match(/h1 \{/)
    end

    it "should not create sass cache" do
      Sass::Plugin.options[:cache] = true
      @hassle.compile

      File.exists?(".sass-cache").should be_false
    end

    it "should compile sass even if disabled with never_update" do
      Sass::Plugin.options[:never_update] = true
      @hassle.compile

      File.exists?(@compiled_path).should be_true
      File.read(@compiled_path).should match(/h1 \{/)
    end
  end
end
