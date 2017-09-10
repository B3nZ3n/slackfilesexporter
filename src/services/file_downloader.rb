require 'net/http'
require 'open-uri'
require 'fileutils'
require 'rest-client'
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

            if chan != "G03NAR0UV" ##showtime
                dir = path+"/"+slack_file.user+"/"
                
            else
                dir = path+"/SHOWTIME/"
            end

            full_path = dir+slack_file.datetime.to_s+"_"+slack_file.file_name
            FileUtils.mkdir_p(dir)
            File.open(full_path, 'wb') { |f|  f << fetch_file(slack_file.link) }

           
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
    

