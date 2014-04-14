class ItemsController < ApplicationController

  def jump
    
    @i = Item.find_by_item_token item_params[:token]
        
    respond_to do |format|
     
      format.html {   
        redirect_to @i.link.uri
      }
      
    end
    
    
  end
  
  private
  
  def item_params
    params.require(:token)
  end

end
