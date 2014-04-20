class ItemsController < ApplicationController

  def jump
    
    @i = Item.find params[:id]
        
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
