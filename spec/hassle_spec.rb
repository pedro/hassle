require File.join(File.dirname(__FILE__), "base")

describe Hassle do
  before do
    Sass::Plugin.options.clear
    Sass::Plugin.options = SASS_OPTIONS
    @hassle = Hassle.new
  end

  #it "dumps css into separate folders" do
  #  @hassle.css_location(Sass::Plugin.options[:css_location]).should ==
  #    File.join(Dir.pwd, "tmp", "hassle", "stylesheets")
  #end

  #it "dumps css into separate folders" do
  #  @hassle.css_location("./public/css").should ==
  #    File.join(Dir.pwd, "tmp", "hassle", "css")
  #end

  describe "compiling sass" do
    before do
      system("git clean -dfxq")
      @default_location = Sass::Plugin.options[:css_location]
    end

    it "moves css into tmp directory with default settings" do
      sass = write_sass(File.join(@default_location, "sass"))

      @hassle.compile

      sass.should be_compiled
    end

    it "should not create sass cache" do
      write_sass(File.join(@default_location, "sass"))
      Sass::Plugin.options[:cache] = true

      @hassle.compile

      File.exists?(".sass-cache").should be_false
    end

    it "should compile sass even if disabled with never_update" do
      sass = write_sass(File.join(@default_location, "sass"))
      Sass::Plugin.options[:never_update] = true

      @hassle.compile

      sass.should be_compiled
    end

    it "should compile sass if template location is a hash" do
      new_location = "public/css/sass"
      Sass::Plugin.options[:template_location] = {new_location => "public/css"}
      sass = write_sass(new_location)

      @hassle.compile

      sass.should be_compiled
    end

    it "should compile sass if template location is a hash with multiple locations" do
      location_one = "public/css/sass"
      location_two = "public/stylesheets/sass"
      Sass::Plugin.options[:template_location] = {location_one => "public/css", location_two => "public/css"}
      sass_one = write_sass(location_one, "one")
      sass_two = write_sass(location_two, "two")

      @hassle.compile

      sass_one.should be_compiled
      sass_two.should be_compiled
    end

    it "should compile sass if template location is an array with multiple locations" do
      location_one = "public/css/sass"
      location_two = "public/stylesheets/sass"
      Sass::Plugin.options[:template_location] = [[location_one, "public/css"], [location_two, "public/css"]]
      sass_one = write_sass(location_one, "one")
      sass_two = write_sass(location_two, "two")

      @hassle.compile

      sass_one.should be_compiled
      sass_two.should be_compiled
    end
  end
end
