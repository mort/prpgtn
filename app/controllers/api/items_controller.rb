class Api::ItemsController < ApiController
    
  before_filter :set_channel
  
  def index
    expose @channel.items
  end

  def show
    expose Item.find(params[:id])
  end
  
  def create
  end
  
  private
  
  def set_channel
    puts params.inspect
    @channel = Channel.find(params[:channel_id])
    
  end
  
  
  
end
