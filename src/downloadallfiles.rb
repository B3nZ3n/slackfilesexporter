require "net/https"
require "uri"
require 'rubygems'
require 'json'
require 'csv'

require_relative "domain/slack_file"
require_relative "services/csv_writer"

token = "xoxp-3633760318-3633833010-238631105570-2e5fb4cbe9f2b60f484bd047a25c0381"
uri = URI.parse("https://slack.com/api/files.list?token=#{token}")
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

request = Net::HTTP::Get.new(uri.request_uri)
response = http.request(request)
parsed = JSON.parse(response.body)

i = 1
pages = parsed["paging"]["pages"]

out = Array.new
while i <= pages  do
    puts "processing page #{i}/#{pages}"
    uri = URI.parse("https://slack.com/api/files.list?token=#{token}&page=#{i}")
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    parsed = JSON.parse(response.body)

    if parsed["files"].nil? 
        puts response.body
    end

    parsed["files"].each { |file| 
        if !file.nil?
            out.push( SlackFile.new(
                file['url_private_download'],
                file['channels'],
                file['user'],
                file['timestamp'],
                file['num_stars']
            ))
        end
    }
        
    i=i+1
    sleep(1.5)
end

writer = CsvWriter.new
writer.write(out,"out.csv")






