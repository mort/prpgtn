class Api::V0::UsersController < ApplicationController
  
  include ActionController::Live
  
  
  def me

    respond_with current_user

  end
  
  
  def index  
  
    respond_with current_user.channels.find(params[:channel_id]).subscribers

  end


  def stream
    
    response.headers['Content-Type'] = 'text/event-stream'
      
    response.stream.write("data:#{ current_user.as_id }\n\n")
      
    Sidekiq.redis { |conn| 
      
      conn.subscribe(current_user.as_id) do |on|
      
        on.message do |event, data|
          response.stream.write("data:#{ data }\n\n")
        end
      
      ensure
               response.stream.close
      end
        
      
    }
    
  end
  
end
