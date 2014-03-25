class Api::V0::SubscriptionsController < ApplicationController
  
  def index
    respond_with current_user.channels.find(params[:channel_id]).users
  end
  
end
