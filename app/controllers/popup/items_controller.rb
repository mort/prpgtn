class Popup::ItemsController < ApplicationController
  before_filter :authenticate_user!
  
  layout 'popup'
  
  def new
  
    @url = params[:url]
    @item = Item.new
    @channels = current_user.channels.collect{|c| [c.title, c.id]}
    
  end
  
  def create
    
    @item = current_user.items.build
    
    @item.on(:create_item_successful) { |item| render :text => 'Peach!' }
    @item.on(:create_item_failed)     { |item| redirect_to new_popup_item_url(:url => item.body) }
    
    @item.commit(item_params)
        
  end
  
  
  private 
  
  def item_params
    
    params.require(:item).permit(:body, :channel_id)

  end
  
end
