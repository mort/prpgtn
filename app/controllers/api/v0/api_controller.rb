class Api::V0::ApiController < ApplicationController
  respond_to :json
  
  doorkeeper_for :all
  
  
  private

  def current_user
    @current_user ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
  
end
