require "net/https"
require "uri"
require 'json'

class FileDeleter
    attr_reader  :token
    
    def initialize(token )
        @token    = token
    end

    def delete(slack_files)

        slack_files.each { |file| 

            uri = URI.parse("https://slack.com/api/files.delete?token=#{token}&file=#{file.id}")
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
            request = Net::HTTP::Get.new(uri)
            response = http.request(request)
            parsed = JSON.parse(response.body)
            puts parsed['ok'] ? "deleted #{file.file_name}" : "not deleted: #{parsed['error']}"
            sleep(1.5)
        }
    end
end