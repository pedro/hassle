require File.join(File.dirname(__FILE__), "base")

describe Hassle do
  before do
    Sass::Plugin.options.clear
    Sass::Plugin.options = SASS_OPTIONS
    @hassle = Hassle.new
  end

  it "uses the current tmp directory by default" do
    @hassle.css_location.should == File.join(Dir.pwd, "tmp", "hassle")
  end

  describe "compiling sass" do
    before do
      system("git clean -dfxq")
      @default_location = Sass::Plugin.options[:css_location]
    end

    it "moves css into tmp directory with default settings" do
      write_sass(File.join(@default_location, "sass"))
      @hassle.compile

      File.exists?(@compiled_path).should be_true
      File.read(@compiled_path).should match(/h1 \{/)
    end

    it "should not create sass cache" do
      write_sass(File.join(@default_location, "sass"))
      Sass::Plugin.options[:cache] = true
      @hassle.compile

      File.exists?(".sass-cache").should be_false
    end

    it "should compile sass even if disabled with never_update" do
      write_sass(File.join(@default_location, "sass"))
      Sass::Plugin.options[:never_update] = true
      @hassle.compile

      File.exists?(@compiled_path).should be_true
      File.read(@compiled_path).should match(/h1 \{/)
    end

    it "should compile sass if template location is a hash" do
      new_location = "public/css/sass"
      write_sass(new_location)
      Sass::Plugin.options[:template_location] = {new_location => "public/css"}
      @hassle.compile

      File.exists?(@compiled_path).should be_true
      File.read(@compiled_path).should match(/h1 \{/)
    end
  end
end
