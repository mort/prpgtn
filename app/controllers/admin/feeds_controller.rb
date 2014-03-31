class Admin::FeedsController < Admin::AdminController
  
  def index
  
    @feeds = Feed.all
  
  end
  
  def show
    
    @feed = Feed.find params[:id]
    
  end
  
end
