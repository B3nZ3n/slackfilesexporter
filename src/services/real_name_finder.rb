require 'json'
require "net/https"

class RealNameFinder
    attr_reader :api_url, :token, :mapping


    def initialize( api_url ,token )
        @api_url       = api_url
        @token      = token

        uri = URI.parse(api_url + "?token=#{token}")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        request = Net::HTTP::Get.new(uri)
        response = http.request(request)
        parsed = JSON.parse(response.body)
        
        @mapping = Hash.new
        parsed["members"].each { |member| 
           # puts "user #{member["id"]} is #{ member["name"]}"
            @mapping[member["id"]] = member["name"]
        }

    end

    def find_name(user_id)
        @mapping[user_id]
    end

    def find_id(user_name)
        @mapping.key(user_name)
    end
end