class SlackFile 
    attr_reader :link, :chans, :user, :datetime, :num_stars, :file_name

    def initialize( link ,chans ,user ,datetime,num_stars,file_name)
        @link       = link
        @chans      = chans
        @user       = user
        @datetime   = datetime
        @num_stars  = num_stars
        @file_name  = file_name
    end
end