
require 'rest_client'

response = RestClient.get 'https://api.typeform.com/v0/form/V88GXR/fields/4185829/blob/3501997d5f5c-how_to_stay_happy_and_healthy_in_old_age_111_x.png?key=808d8be7a13edb42e0d6eaa4bb2193ba76a07e26'

# RestClient.get 'http://example.com/resource', {:params => {:id => 50, 'foo' => 'bar'}}

# RestClient.get 'https://user:password@example.com/private/resource', {:accept => :json}

# RestClient.post 'http://example.com/resource', :param1 => 'one', :nested => { :param2 => 'two' }

# RestClient.post "http://example.com/resource", { 'x' => 1 }.to_json, :content_type => :json, :accept => :json

# RestClient.delete 'http://example.com/resource'

# response = RestClient.get 'http://example.com/resource'
puts response.code
# ➔ 200
puts response.cookies
# ➔ {"Foo"=>"BAR", "QUUX"=>"QUUUUX"}
puts response.headers
# ➔ {:content_type=>"text/html; charset=utf-8", :cache_control=>"private" ...
puts response.to_str
# ➔ \n<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01//EN\"\n   \"http://www.w3.org/TR/html4/strict.dtd\">\n\n<html ....

