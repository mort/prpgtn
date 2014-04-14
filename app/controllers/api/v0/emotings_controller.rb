class Api::V0::EmotingsController < Api::V0::ApiController

  def create
    
    item = Item.find(params[:item_id])
  
    if item && item.is_for?(current_user)
      
      emote = item.channel.emotes.find(emoting_params[:emote_id])
      
        if emote 
          
          emoting = current_user.emotings.build(item_id: item.id)
          emoting.subscribe(ActivityListener.new)
          
          emoting.on(:create_emoting_successful) { |emoting| render nothing: true, status: 201 }
          emoting.on(:create_emoting_failed)     { |emoting| render json: emoting.errors.as_json, :status => :unprocessable_entity }
  
          emoting.commit(emoting_params)
        
      end
  
    end
  
  end

  
  def destroy
  
    e = current_user.emotings.find params[:emoting_id]
    
    if e.destroy
      render status: 200
    end
  
  
  end
  
  
  private
  
  def emoting_params

    params.require(:emoting).permit(:emote_id)


  end
  

end
