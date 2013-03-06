describe 'The Trafic Spy App' do
  include Rack::Test::Methods

  def app
    TrafficSpy::Application
  end


end
