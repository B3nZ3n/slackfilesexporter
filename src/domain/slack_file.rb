class SlackFile 
    attr_reader :link, :chans, :user, :datetime, :num_stars

    def initialize( link ,chans ,user ,datetime,num_stars)
        @link       = link
        @chans      = chans
        @user       = user
        @datetime   = datetime
        @num_stars  = num_stars
    end
end