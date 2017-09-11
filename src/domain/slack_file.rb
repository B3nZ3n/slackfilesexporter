class SlackFile 
    attr_reader :link, :chans, :user_id, :user_name, :datetime, :num_stars, :file_name, :id, :title

    def initialize( link ,chans ,user_id, user_name ,datetime,num_stars,file_name,id,title)
        @link       = link
        @chans      = chans
        @user_id    = user_id
        @user_name  = user_name
        @datetime   = datetime
        @num_stars  = num_stars
        @file_name  = file_name
        @id         = id
        @title      = title
    end
end