require "net/https"
require "uri"
require 'rubygems'
require 'json'
require 'csv'
require 'date'


require_relative "domain/slack_file"
require_relative "services/csv_writer"
require_relative "services/file_downloader"
require_relative "services/real_name_finder"

token = ARGV[0] 
uri = URI.parse("https://slack.com/api/files.list?token=#{token}")
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

request = Net::HTTP::Get.new(uri.request_uri)
response = http.request(request)
parsed = JSON.parse(response.body)

i = 1
pages = parsed["paging"]["pages"]
pages =1
out = Array.new

name_finder = RealNameFinder.new("https://slack.com/api/users.list",token)


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
                name_finder.find_name(file['user']),
                Time.at(file['timestamp']).to_datetime.strftime('%F'),
                file['num_stars'],
                file['name']
            ))
        end
    }
        
    i=i+1
    sleep(1.5)
end

writer = CsvWriter.new
writer.write(out,"out.csv")

downloader = FileDownloader.new("./fichiers/",token)
downloader.download(out)





