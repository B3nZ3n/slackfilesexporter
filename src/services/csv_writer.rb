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
            ["link" ,"chans" ,"user" ,"datetime","num_stars"]
       end

       def create_row(slackfile)

        [slackfile.link,
        slackfile.chans[0],
        slackfile.user,
        slackfile.datetime,
        slackfile.num_stars.nil? ? 0 : slackfile.num_stars ]
       end
    
      
    end
    