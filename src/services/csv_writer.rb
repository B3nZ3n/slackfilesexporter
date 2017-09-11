require 'date'
class CsvWriter
    
    def write(input, path)
        to_write = input.map {|slackfile| create_row(slackfile)}
        to_write.unshift(generate_headers)
        File.open(path,"w"){ |f| f << to_write.map(&:to_csv).join} 
        puts "CSV File saved"
    end
    
    
    private
    def generate_headers
        ["id","link" ,"chans" ,"user_id", "user_name" ,"datetime","num_stars","file_name","title"]
    end

    def create_row(slackfile)
        [slackfile.id,
        slackfile.link,
        slackfile.chans[0],
        slackfile.user_id,
        slackfile.user_name,
        slackfile.datetime,
        slackfile.num_stars.nil? ? 0 : slackfile.num_stars ,
        slackfile.file_name,
        slackfile.title]
    end
end
    