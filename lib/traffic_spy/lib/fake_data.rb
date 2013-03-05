module TrafficSpy
  class FakeData
      
    def self.make_fake_data
      Identifier.add_to_database({:identifier => "zappos", :rootUrl => "http://zappos.com"})
      5.times do
        Payload.add_to_database({:url => "http://zappos.com/shoes",
                      :requestedAt => "2013-02-16 21:38:28 -0700",
                      :splat => ["zappos"],
                      :respondedIn => 25,
                      :referredBy => "http://findshoes.com",
                      :requestType => "GET",
                      :parameters => "[]",
                      :eventName => "searchFind",
                      :userAgent => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
                      :resolutionWidth => "1920",
                      :resolutionHeight => "1080",
                      :ip => "123.456.789.0"})
      end
      Payload.add_to_database({:url => "http://zappos.com/socks",
                      :requestedAt => "2012-07-16 21:38:28 -0700",
                      :splat => ["zappos"],
                      :respondedIn => 123,
                      :referredBy => "http://findsocks.com",
                      :requestType => "GET",
                      :parameters => "[]",
                      :eventName => "sockFind",
                      :userAgent => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
                      :resolutionWidth => "1923",
                      :resolutionHeight => "1782.3",
                      :ip => "343.426.759.0"})
      Payload.add_to_database({:url => "http://zappos.com/shoes",
                      :requestedAt => "2012-02-16 16:33:19 -0700",
                      :splat => ["zappos"],
                      :respondedIn => 25,
                      :referredBy => "http://findshoes.com",
                      :requestType => "GET",
                      :parameters => "[]",
                      :eventName => "searchFind",
                      :userAgent => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
                      :resolutionWidth => "1924",
                      :resolutionHeight => "1080",
                      :ip => "123.456.789.0"})

    end


  end
end

