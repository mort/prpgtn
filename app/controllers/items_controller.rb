class ItemsController < ApplicationController
  before_filter :authenticate_user!, :except => [:jump]
  
  
  def jump
    
    @i = current_user.channels.find(params[:channel_id]).items.find params[:id]
        
    respond_to do |format|
     
      format.html {   
        redirect_to @i.link.uri
      }
      
    end
    
    
  end

end
