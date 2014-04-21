class Api::V0::ForwardingsController < Api::V0::ApiController

  
  def create
  
    item = Item.find(params[:item_id])
    channel = current_user.channels.find(fwd_params[:channel_id])
    
    if item.is_for?(current_user) && channel
    
      fwd = current_user.forwardings.build(item_id: item.id)
    
      fwd.on(:create_forwarding_successful) { |forwarding| render nothing: true, status: 201 }
      fwd.on(:create_forwarding_failed)     { |forwarding| render json: forwarding.errors.as_json, :status => :unprocessable_entity }

      fwd.commit(fwd_params)
            
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
    params.require(:forwarding).permit(:channel_id)
  end
  

end
