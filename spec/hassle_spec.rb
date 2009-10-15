require File.dirname(__FILE__) + '/base'

describe Hassle do
  include Rack::Test::Methods

  def app
    Rack::Builder.new do
      use Hassle
      run Proc.new {|env| [200, {"Content-Type" => "text/html"}, "hello!"]}
    end
  end

  before do
    reset
  end

  it "sends through basic responses" do
    get '/'
    last_response.status.should == 200
    last_response.body.should =~ /hello!/
  end

  describe "a basic setup" do
    before do
      write_sass("./public/stylesheets/sass")
    end

    it "serves up some sass" do
      get '/stylesheets/screen.css'
      last_response.should have_served_sass
    end
  end

  describe "a slightly more complex setup" do
    before do
      @location_one = "./public/css/sass"
      @location_two = "./public/stylesheets/sass"
      Sass::Plugin.options[:template_location] = { @location_one => "public/css",
                                                   @location_two => "public/css"}
      write_sass(@location_one, "style")
      write_sass(@location_two, "application")
    end

    it "serves up some sass from the normal location" do
      get '/stylesheets/application.css'
      last_response.should have_served_sass
    end

    it "serves up some sass from a different location" do
      get '/css/style.css'
      last_response.should have_served_sass
    end
  end
end
