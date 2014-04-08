class RobotoRequestsController < ApplicationController
  before_filter :authenticate_user!
  
    
  def show
  
    @r = current_user.roboto_requests.find params[:id]
  
  end  
    
  def create
    
    channel = current_user.channels.find params[:channel_id] 
    req = current_user.roboto_requests.build(req_params)
    req.channel = channel
      
    if req.save

      
      respond_to do |format|

        format.html {
          redirect_to roboto_request_path(req), notice: 'Roboto created'
        }
      
      end
    
    end  
    
  end
  
  
  private
  
  def req_params
    params.require(:roboto_request).permit(:uri)
  end

end
