class Admin::FeedsController < Admin::AdminController
  
  def index
    @feeds = Feed.all
  end
  
  def show
    @feed = Feed.find params[:id]
  end
  
  def new
    @feed = Feed.new
  end
  
  def create
    
    @feed = Feed.new(feed_params)
    @feed.admin_created = true
    
    if @feed.save
      
      respond_to do |format|
      
        format.html {
          redirect_to admin_feeds_path, notice: 'Feed created'
        }
      
      end
        
      
    else
      
      respond_to do |format|
      
        format.html {
          render action: 'new'
        }
      
      end
      
        
    end

    
  end
  
  
  private 
  
  
  def feed_params
    params.require(:feed).permit(:submitted_uri) 
  end
  
  
end
