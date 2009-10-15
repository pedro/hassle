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
    write_sass("./public/stylesheets/sass")
  end

  it "sends through basic responses" do
    get '/'
    last_response.status.should == 200
    last_response.body.should =~ /hello!/
  end

  it "compiles some sass" do
    get '/stylesheets/screen.css'
    last_response.status.should == 200
    last_response.body.should =~ /h1 \{/
    last_response.headers['Cache-Control'].should =~ /max-age=86400/
  end
end
