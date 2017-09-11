require "net/https"
require "uri"
require 'rubygems'
require 'json'
require 'csv'
require 'date'

require_relative "domain/slack_file"
require_relative "services/csv_writer"
require_relative "services/file_downloader"
require_relative "services/file_deleter"
require_relative "services/real_name_finder"

token = ARGV[0] 
name_finder = RealNameFinder.new("https://slack.com/api/users.list",token)
user_filter = name_finder.find_id(ARGV[1])

uri = URI.parse("https://slack.com/api/files.list?token=#{token}&user=#{user_filter}")
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

request = Net::HTTP::Get.new(uri.request_uri)
response = http.request(request)
parsed = JSON.parse(response.body)

i = 1
pages = parsed["paging"]["pages"]

file_list = Array.new



while i <= pages  do
    puts "processing page #{i}/#{pages}"
    uri = URI.parse("https://slack.com/api/files.list?token=#{token}&page=#{i}&user=#{user_filter}")
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    parsed = JSON.parse(response.body)

    if parsed["files"].nil? 
        puts response.body
    end

    parsed["files"].each { |file| 
        if !file.nil?
            file_list.push( SlackFile.new(
                file['url_private_download'],
                file['channels'],
                file['user'],
                name_finder.find_name(file['user']),
                Time.at(file['timestamp'].to_i).to_datetime.strftime('%FT%H_%M_%S'),
                file['num_stars'],
                file['name'],
                file['id'],
                file['title']
            ))
        end
    }
        
    i=i+1
    sleep(1.5)
end

writer = CsvWriter.new
writer.write(file_list,"out.csv")

downloader = FileDownloader.new("./fichiers",token)
downloader.download(file_list)

deleter = FileDeleter.new(token)
deleter.delete(file_list)




