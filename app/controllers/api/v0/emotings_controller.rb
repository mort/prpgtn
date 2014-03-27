class Api::V0::EmotingsController < Api::V0::ApiController

  def create
  
    Item.find(emoting_params[:item_id])
  
    if item.is_for?(current_user)

      emoting = current_user.emotings.build(emoting_params)
    
      if emoting.save
        render status: 201
      else
        respond_with @emoting.errors.full_messages, :status => :unprocessable_entity 
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

    params.require(:emoting).permit(:item_id, :emote_id)
    
  end

end
