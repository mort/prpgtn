class Popup::ItemsController < ApplicationController
  before_filter :authenticate_user!
  
  layout 'popup'
  
  def new
  
    @url = params[:url]
    @item = Item.new
    @channels = current_user.channels.collect{|c| [c.title, c.id]}
    
  end
  
  def create
    
    @item = current_user.items.build(item_params)
    
    if @item.save!
      respond_to do |format|
        format.html { render :text => 'Propagated!' }
      end
      
    else
      
      respond_to do |format|
        format.html { redirect_to new_popup_item_url(:url => @item.body) }
      end
    end
    
    
  end
  
  
  private 
  
  def item_params
    
    params.require(:item).permit(:body, :channel_id)

  end
  
end
