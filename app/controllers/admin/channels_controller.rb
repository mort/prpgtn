class Admin::ChannelsController < Admin::AdminController
  before_filter :get_channel, :except => [:index]
  
  
  def index
    @channels = Channel.all
  end
  
  def show
  end
  
  def subscribers
  end
  
  def items
  end
  
  private
  
  def get_channel
     @channel = Channel.find params[:id]
  end
  
end
