require "net/http"
require 'json'
require 'uri'
require 'openssl' # import

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE # check certificate off

my_hash = {
  :name => "John",
  :age => 25,
  :phones => ["+1-9920394631", "+1-8928374743"],
  :address => {
    :city => "New York",
    :country => "USA"
  }
} # dict (?) for future json doc

data = JSON.generate(my_hash) # generating json

uri = URI('http://localhost:80') # uri to send

https = Net::HTTP.new(uri.host, uri.port) 
https.use_ssl = false

request = Net::HTTP::Post.new(uri.path) # define a post request
request.body = data # add to body out json doc
request["Content-Type"] = "application/json" # add type

response = https.request(request) # send request
# response
puts response.code
puts response.body
