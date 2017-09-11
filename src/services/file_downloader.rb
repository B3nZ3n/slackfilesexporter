require 'net/http'
require 'open-uri'
require 'fileutils'
require 'rest-client'
require 'uri'

class FileDownloader
    attr_reader :path , :tooken
    
    def initialize( path,token )
        @path    = path
        @token    = token
    end

    def download(slack_files)
        slack_files.each{ |slack_file | 
            puts "downloading #{slack_file.link}"
            chan = slack_file.chans[0].nil? ? "mp" : slack_file.chans[0]

            begin
                uri = URI.parse(slack_file.link)
                file_name =  File.basename(uri.path)
          

                if chan != "G03NAR0UV" ##showtime
                    dir = path+"/"+slack_file.user_name+"/"
                else
                    dir = path+"/SHOWTIME/"
                end

                full_path = dir+slack_file.datetime.to_s+"_" + file_name

                if !File.exist?(dir)
                    FileUtils.mkdir_p(dir)
                end

                if !File.exist?(full_path)
                    File.open(full_path, 'wb') { |f|  f << fetch_file(slack_file.link) }
                else
                    puts "#{full_path} already exist, skipping"
                end
            rescue => e
                puts "An error of type #{e.class} happened, message is #{e.message}. For file #{slack_file.id}"
            end
        }
    end


    def fetch_file(url)
        res = RestClient.get(url, { "Authorization" => "Bearer #{@token}" })
      
        if res.code == 200
          return res.body
        else
          raise 'Download failed'
        end
      end

        
end
    

