class Api::V0::ForwardingsController < Api::V0::ApiController

  
  def create
  
    item = Item.find(fwd_params[:item_id])
    
    if item.is_for?(current_user)
    
      fwd = current_user.forwardings.build(fwd_params)
    
      if fwd.save
        render status: 201
      else
        respond_with fwd.errors.full_messages, :status => :unprocessable_entity 
      end
      
    end
  end
  
  def destroy
  
    f = current_user.forwardings.find params[:forwarding_id]
    
    if f.destroy
      render status: 200
    end
  
  
  end
  
  
  private
  
  def fwd_params
  
    params.require(:forwarding).permit(:item_id, :channel_id)
  
  end
  

end
