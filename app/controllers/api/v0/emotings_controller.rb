class Api::V0::EmotingsController < Api::V0::ApiController

  def create
    
    item = Item.find(params[:item_id])
  
    if item && item.is_for?(current_user)

      emote = item.channel.emotes.find(params[:emote_id])
      
        if emote 
      
          emoting = current_user.emotings.build(item_id: item.id, emote_id: emote.id)
    
          if emoting.save
            render nothing: true, status: 201
          else
            respond_with emoting.errors.full_messages, :status => :unprocessable_entity 
          end
  
      end
  
    end
  
  end

  
  def destroy
  
    e = current_user.emotings.find params[:emoting_id]
    
    if e.destroy
      render status: 200
    end
  
  
  end


end
