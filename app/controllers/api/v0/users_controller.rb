class Api::V0::UsersController < Api::V0::ApiController
  
  def me

    respond_with current_user

  end
  
  
  def index
  
    respond_with current_user.channels.find(params[:channel_id]).subscribers
  
  end

  
end
