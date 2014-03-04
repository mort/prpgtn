class Api::ItemsController < ApiController
    
  before_filter :set_channel
  
  def index
    expose @channel.items.with_link.order("link_fetched_at DESC").limit(2), :include => [:link, :user]
  end
  
  def create
  end
  
  private
  
  def set_channel
    puts params.inspect
    @channel = Channel.find(params[:channel_id])
  end
  
  
  
end
