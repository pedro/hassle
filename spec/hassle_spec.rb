require File.dirname(__FILE__) + '/base'

describe Hassle do
  include Rack::Test::Methods

  def app
    Rack::Builder.new do
      use Hassle
      run Proc.new {|env| [200, {"Content-Type" => "text/html"}, env.inspect]}
    end
  end

  it "returns basic response" do
    get '/'
    last_response.status.should == 200
  end
end
